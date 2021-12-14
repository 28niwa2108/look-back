FactoryBot.define do
  factory :contract_renewal do
    renewal_count    { Faker::Number.between(from: 1, to: 3) }
    total_price      { Faker::Number.number(digits: 4) }
    total_period     { Faker::Number.number(digits: 3) }
    next_update_date { Faker::Date.between(from: '2021-12-13', to: '2022-12-13') }
    association :subscription
  end
end
