# frozen_string_literal: true

class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 10.minutes
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  MAILER_FROM_EMAIL = "no-reply@stadac.one"

  attr_accessor :current_password

  has_secure_password
  has_many :active_sessions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :permissions

  after_initialize :check_permissions
  before_save :downcase_email
  before_save :downcase_unconfirmed_email

  validates :username, obscenity: true, presence: true, uniqueness: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true
  validates :unconfirmed_email, format: {with: URI::MailTo::EMAIL_REGEXP, allow_blank: true}

  def confirm!
    if confirmed?
      return false
    end

    if unconfirmed_email.present?
      update(email: unconfirmed_email, unconfirmed_email: nil)
    end
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def unconfirmed?
    !confirmed?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_later
  end

  def confirmable_email
    if unconfirmed_email.present?
      unconfirmed_email
    else
      email
    end
  end

  def reconfirming?
    unconfirmed_email.present?
  end

  def unconfirmed_or_reconfirming?
    unconfirmed? || reconfirming?
  end

  def generate_password_reset_token
    signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_now
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def downcase_unconfirmed_email
    return if unconfirmed_email.nil?
    self.unconfirmed_email = unconfirmed_email.downcase
  end

  # @note performance could and should probably be improved. Naive approach used, but functional
  # @note could also refactor to fetch base permissions from resources who expose them instead of breaking OCP. Works for our need for now.
  def check_permissions
    base = [
      Permission.find_or_create_by(resource: "posts", action: "index"),
      Permission.find_or_create_by(resource: "posts", action: "show"),
      Permission.find_or_create_by(resource: "posts", action: "new"),
      Permission.find_or_create_by(resource: "posts", action: "create"),
      Permission.find_or_create_by(resource: "posts", action: "update"),
      Permission.find_or_create_by(resource: "posts", action: "edit"),
      Permission.find_or_create_by(resource: "posts", action: "upvote"),
      Permission.find_or_create_by(resource: "posts", action: "downvote"),
      Permission.find_or_create_by(resource: "posts", action: "unvote"),
      Permission.find_or_create_by(resource: "posts", action: "destroy"),
      Permission.find_or_create_by(resource: "users", action: "new"),
      Permission.find_or_create_by(resource: "users", action: "create"),
      Permission.find_or_create_by(resource: "users", action: "update"),
      Permission.find_or_create_by(resource: "users", action: "edit"),
      Permission.find_or_create_by(resource: "sessions", action: "new"),
      Permission.find_or_create_by(resource: "sessions", action: "create"),
      Permission.find_or_create_by(resource: "sessions", action: "destroy"),
      Permission.find_or_create_by(resource: "confirmations", action: "new"),
      Permission.find_or_create_by(resource: "confirmations", action: "create"),
      Permission.find_or_create_by(resource: "confirmations", action: "edit"),
      Permission.find_or_create_by(resource: "comments", action: "create"),
      Permission.find_or_create_by(resource: "comments", action: "destroy")
    ]

    base.each do |permission|
      unless permission.in? permissions
        permissions.push(permission)
      end
    end
  end
end
