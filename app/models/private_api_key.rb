class PrivateApiKey < ApplicationRecord
  validates :value, presence: true, uniqueness: true
end
