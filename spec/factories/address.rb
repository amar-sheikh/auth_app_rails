FactoryBot.define do
  factory :address do
    association :user, strategy: :build

    sequence(:line1)   { |n| "line1-#{n}" }
    sequence(:line2)   { |n| "line2-#{n}" }
    sequence(:city)    { |n| "city-#{n}" }
    sequence(:country) { |n| "country-#{n}" }
    sequence(:postcode){ |n| "postcode-#{n}" }

    created_at { 1.year.ago.in_time_zone('London') }
    updated_at { 1.year.ago.in_time_zone('London') }

    transient do
      transactions_count { 0 }
    end

    after(:create) do |address, evaluator|
      address.user.update(current_address: address) if address.user
      create_list(:transaction, evaluator.transactions_count, address: address) if evaluator.transactions_count.positive?
    end

    trait :with_timetable_views do
      transactions_count { 1 }
    end
  end
end
