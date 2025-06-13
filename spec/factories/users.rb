FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@me.com" }
    confirmed_at { Time.now.in_time_zone('London') }
    created_at { Time.now.in_time_zone('London') - 1.year }
    updated_at { Time.now.in_time_zone('London') - 1.year }
    password { 'password' }

    trait :invalid do
      email { 'a' }
    end

    transient do
      build_confirmed { true }
    end

    after(:build) do |user, evaluator|
      if evaluator.build_confirmed
        user.confirm
      else
        user.skip_confirmation_notification!
      end
    end

    to_create { |instance| instance.save(validate: false) }

    trait :unconfirmed do
      confirmed_at { nil }

      transient do
        build_confirmed { false }
      end
    end
  end
end
