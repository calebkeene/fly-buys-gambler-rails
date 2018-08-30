class FlyBuysCard < ApplicationRecord
  belongs_to :member

  validates :number, :balance, presence: true
  validate :number_format

  VALID_FORMAT = /(6014)-\d{4}-\d{4}-\d{4}/.freeze

  private

  def number_format
    format_regexp = VALID_FORMAT
    errors.add(:number, "incorrect format card number") unless number =~ format_regexp
  end
end
