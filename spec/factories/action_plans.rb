FactoryBot.define do
  factory :action_plan do
    action_rate           { Faker::Number.between(from: 1, to: 5) }
    action_review_comment { Faker::Lorem.sentence }
    action_plan           { Faker::Lorem.sentence }
    association :review
  end
end
