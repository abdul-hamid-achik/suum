FactoryBot.define do
  factory :user do
    name do
      Faker::Name.unique.name
    end
    email { Faker::Internet.unique.email }
    password { '12345678' }

    confirmed_at { DateTime.now }
  end
end
