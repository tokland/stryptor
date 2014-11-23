FactoryGirl.define do
  factory :strip_collection do
    sequence(:code, &:to_s)
    name { |collection| collection.code }
    footer "<p>Footer</p>"
    image_url "http://server.org/:code.jpg"
  end

  factory :strip do
    sequence(:position)
    sequence(:code, &:to_s)
    image File.open(Rails.root.join("spec/fixtures/mafalda-01_001.jpg"))
    strip_collection
  end
end
