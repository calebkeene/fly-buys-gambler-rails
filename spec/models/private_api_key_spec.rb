require 'rails_helper'

RSpec.describe PrivateApiKey, type: :model do
  it { should validate_presence_of(:value) }
  it { should validate_uniqueness_of(:value) }
end
