FactoryGirl.define do
  factory :attendee, class: Refinery::Calendar::Attendee do
    event
    sequence(:name)  { |n| "refinery#{n}" }
    sequence(:email) { |n| "refinery#{n}@example.com" }
  end
end
