# syntax = docker/dockerfile:1

# Base image for building shared stuff between dev and prod
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION-slim as base

# Update gems and bundler
RUN gem update --system --no-document && \
    gem install -N bundler

FROM base as dev

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential pkg-config

# Install gem dependices in container
COPY --link Gemfile Gemfile.lock ./
RUN bundle install

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
FROM base as prod

LABEL fly_launch_runtime="rails"

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="1"


# Throw-away build stage to reduce size of final image
FROM prod as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential pkg-config

# Install application gems
COPY --link Gemfile Gemfile.lock ./
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf ~/.bundle/ $BUNDLE_PATH/ruby/*/cache $BUNDLE_PATH/ruby/*/bundler/gems/*/.git

# Copy application code
COPY --link . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM prod

# Install, configure litefs
COPY --from=flyio/litefs:0.4.0 /usr/local/bin/litefs /usr/local/bin/litefs
COPY --link config/litefs.yml /etc/litefs.yml

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y ca-certificates curl fuse3 libsqlite3-0 sudo && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    mkdir /data /litefs && \
    chown -R rails:rails db log storage tmp /data /litefs

# Authorize rails user to launch litefs
COPY <<-"EOF" /etc/sudoers.d/rails
rails ALL=(root) /usr/local/bin/litefs
EOF

# Deployment options
ENV DATABASE_URL="sqlite3:///litefs/production.sqlite3" \
    PORT="3001"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
VOLUME /data
CMD ["./bin/rails", "server"]
