FactoryGirl.define do
  factory :event, class: Refinery::Calendar::Event do
    organizer        { FactoryGirl.create(:user) }
    sequence(:title) { |n| "refinery#{n}" }
    starts_at        { Time.now + 1.week }
    ends_at          { Time.now + 1.week + 2.hours }

    factory :private_event do
      is_private true
    end

    factory :past_event do
      starts_at { Time.now - 1.week }
      ends_at   { Time.now - 1.week + 2.hours }
    end
  end
end

