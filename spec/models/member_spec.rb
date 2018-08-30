require 'rails_helper'

RSpec.describe Member, type: :model do
  %i[name email].each do |attribute|
    it { should validate_presence_of(attribute) }
  end
end
