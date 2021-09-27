FactoryBot.define do
  factory :transmission do
    title { "MyString" }
    views { 1 }
    public? { false }
    user { nil }
  end
end
