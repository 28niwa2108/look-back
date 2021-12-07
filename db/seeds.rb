require 'date'

user = User.new(
  email: 'test@email.com',
  password: "test123",
  nickname: "サブsub"
)
user.save

d_subs = []
m_subs = []
y_subs = []

10.times do |i|
  d_subs << Subscription.new(
    user_id: user.id,
    name: "サブスクー#{i + 1}",
    price: 3000,
    contract_date: Date.parse('2021-12-1'),
    update_type_id: 1,
    update_cycle: 30,
    update_day_type_id: nil
  )
end

update_day_type = 1
10.times do |i|
  update_day_type = 2 if i > 4 
  m_subs << Subscription.new(
    user_id: user.id,
    name: "Mサブスク#{i  + 1}",
    price: 3000,
    contract_date: Date.parse('2021-12-1'),
    update_type_id: 2,
    update_cycle: 1,
    update_day_type_id: update_day_type
  )
end

update_day_type = 1
10.times do |i|
  update_day_type = 2 if i > 4 
  y_subs << Subscription.new(
    user_id: user.id,
    name: "Yサブスクー#{i + 1}",
    price: 3000,
    contract_date: Date.parse('2021-12-1'),
    update_type_id: 3,
    update_cycle: 1,
    update_day_type_id: update_day_type
  )
end

Subscription.import d_subs
Subscription.import m_subs
Subscription.import y_subs
