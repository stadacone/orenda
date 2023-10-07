# orenda

## Setup

Install [asdf](https://asdf-vm.com/). It should handle the setup of `ruby` and `bun` for the project.

Run `bundle install` and `bun install` to install project dependencies.

Run `rails db:migrate` to setup your database for development.

`rails server` will start the development server. You can also use your favourite IDE to run a debugger.

## Contributing

We use [Rubocop](https://github.com/rubocop/rubocop) as our linter and formater. 
You can usually setup your IDE to run it while you code.
If you don't, your code will be checked and rejected automatically for any lint and format violations during the PR cycle. 

## Deployment

All successful builds against the `main` branch are automatically deployed to [fly.io](https://fly.io/).