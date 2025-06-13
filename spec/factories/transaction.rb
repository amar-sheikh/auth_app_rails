FactoryBot.define do
  factory :transaction do
    association :user, strategy: :build

    idempotency_key { SecureRandom.hex(8) }
    amount { 1 }
    additional_info { "" }

    created_at { 1.year.ago.in_time_zone('London') }
    updated_at { 1.year.ago.in_time_zone('London') }

    trait :with_address do
      association :address, strategy: :build
    end
  end
end
