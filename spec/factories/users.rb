FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 123123 }
  end
end
