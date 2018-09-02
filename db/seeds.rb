
ENV["RAILS_ENV"] ||= "development"

PrivateApiKey.create(value: "0101-1122-3344-5566")

ActiveRecord::Base.transaction do
  member = Member.create!(name: "Caleb", email: "caleb@gmail.com", password: "password")

  FlyBuysCard.create!(
    number: "6014-1111-2222-3333-4444",
    balance: 100,
    member: member
  )
end
