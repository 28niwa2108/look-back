FactoryBot.define do
  factory :subscription do
    name               { Faker::Lorem.characters(number: 6) }
    price              { Faker::Number.number(digits: 4) }
    contract_date      { Faker::Date.between(from: '2019-09-23', to: '2020-09-23') }
    update_type_id     { Faker::Number.between(from: 1, to: 3) }
    update_cycle       { Faker::Number.between(from: 1, to: 31) }
    update_day_type_id { Faker::Number.between(from: 1, to: 2) }
    association :user
  end
end
