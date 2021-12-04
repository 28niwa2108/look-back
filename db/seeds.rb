require 'date'

user = User.new(
  email: 'test@email.com',
  password: "test123",
  nickname: "サブsub",
)
user.save

subs = []
10.times do |i|
  subs << Subscription.new(
    user_id: user.id,
    name: "#{i}サブスク",
    price: 3000,
    contract_date: Date.parse('2021-12-1'),
    update_type_id: 1,
    update_cycle: 30
  )
end
Subscription.import subs
