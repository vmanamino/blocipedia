FactoryGirl.define do
  factory :user do
    name 'Douglas Adams'
    sequence(:email) { |n| "person#{n}@example.com" } # rubocop:disable Lint/UnusedBlockArgument
    password 'helloworld'
    password_confirmation 'helloworld'
    confirmed_at Time.now # rubocop:disable Rails/TimeZone
  end
end
