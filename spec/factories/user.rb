require 'faker'

FactoryBot.define do 
  factory :user do
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    full_name { Faker::Name.name }
    password { Faker::Internet.password }
    metadata { Faker::Lorem.sentence }
  end
end