class Member < ApplicationRecord
  before_save :encrypt_password
  after_save :clear_unencrypted_password
  has_one :fly_buys_card, dependent: :destroy

  VALID_EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i.freeze

  attr_accessor :password

  validates_associated :fly_buys_card
  validates_format_of :email, with: VALID_EMAIL_FORMAT
  validates :name, :email, presence: true, uniqueness: true

  def self.valid_password?(member, password)
    BCrypt::Password.new(member.encrypted_password) == password
  end

  private

  def encrypt_password
    return unless password.present?
    self.encrypted_password = BCrypt::Password.create(password)
  end

  def clear_unencrypted_password
    self.password = nil
  end
end
