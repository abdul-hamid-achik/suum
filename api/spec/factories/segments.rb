FactoryBot.define do
  factory :segment do
    file_data { "MyText" }
    duration { 1 }
    transmission { nil }
    timestamp { "2021-09-26 15:48:29" }
    filename { "MyString" }
  end
end
