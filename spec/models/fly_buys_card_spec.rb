require 'rails_helper'

RSpec.describe FlyBuysCard, type: :model do
  %i[number balance].each do |attribute|
    it { should validate_presence_of(attribute) }
  end
end
