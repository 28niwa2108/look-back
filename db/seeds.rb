require 'date'

subs = []
10.times do |i|
  subs << Subscription.new(
    user_id: 1,
    name: "#{i}サブスク",
    price: 3000,
    contract_date: Date.parse('2021-12-1'),
    update_type_id: 1,
    update_cycle: 30
  )
end
Subscription.import subs
