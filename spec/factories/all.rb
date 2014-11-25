FactoryGirl.define do
  factory :user do
    name "Name"
    email "Email"
    provider "facebook"
    sequence(:uid, &:to_s) 
  end
  
  factory :strip_collection do
    sequence(:code, &:to_s)
    name { |collection| collection.code }
    footer "<p>Footer</p>"
    image_url "http://server.org/:code.jpg"
  end

  factory :strip do
    sequence(:position)
    sequence(:code, &:to_s)
    strip_collection
  end
end
