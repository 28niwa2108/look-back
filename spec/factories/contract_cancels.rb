FactoryBot.define do
  factory :contract_cancel do
    cancel_date    { Faker::Date.between(from: '2020-12-13', to: '2021-12-13') }
    reason_id      { Faker::Number.between(from: 1, to: 6) }
    cancel_comment { Faker::Lorem.sentence }
    association :subscription
  end
end
