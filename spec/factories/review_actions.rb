FactoryBot.define do
  factory :review_action do
    review_rate           { Faker::Number.between(from: 1, to: 5) }
    review_comment        { Faker::Lorem.sentence }
    start_date            { Faker::Date.between(from: '2020-09-23', to: '2020-12-25') }
    end_date              { Faker::Date.between(from: '2021-09-23', to: '2022-09-25') }
    later_check_id        { Faker::Number.between(from: 1, to: 2) }
    action_rate           { Faker::Number.between(from: 1, to: 5) }
    action_review_comment { Faker::Lorem.sentence }
    action_plan           { Faker::Lorem.sentence }
  end
end
