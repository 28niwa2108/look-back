#User---------------------------------
user = User.new(
  email: 'test@email.com',
  password: "test123",
  nickname: "サブsub"
)
user.save

#Subscription---------------------------------
d_subs = []
m_subs = []
y_subs = []

5.times do |i|
  d_subs << Subscription.new(
    user_id: user.id,
    name: "サブスクー#{i + 1}",
    price: 3000,
    contract_date: Date.parse('2021-12-1'),
    update_type_id: 1,
    update_cycle: 20,
    update_day_type_id: nil,
    id: i + 1
  )
end

update_day_type = 1
num = 6
10.times do |i|
  update_day_type = 2 if i > 4 
  m_subs << Subscription.new(
    user_id: user.id,
    name: "Mサブスク#{i  + 1}",
    price: 3000,
    contract_date: Date.parse('2021-12-1'),
    update_type_id: 2,
    update_cycle: 1,
    update_day_type_id: update_day_type,
    id: num
  )
  num += 1
end

num = 16
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
    update_day_type_id: update_day_type,
    id: num
  )
  num += 1
end

Subscription.import d_subs
Subscription.import m_subs
Subscription.import y_subs

#ContractRenewal---------------------------------
d_cons = []
m_cons = []
y_cons = []

5.times do |i|
  d_cons << ContractRenewal.new(
    renewal_count: 0,
    total_price: Subscription.find(i+1).price,
    total_period: 20,
    update_date: Date.parse('2021-12-1'),
    next_update_date: Date.parse('2021-12-21'),
    subscription_id: Subscription.find(i+1).id
  )
end

index = 6
date = Date.parse('2021-12-21').next_month.beginning_of_month
10.times do |i|
  date = Date.parse('2021-12-21').next_month if i > 4 
  m_cons << ContractRenewal.new(
    renewal_count: 0,
    total_price: Subscription.find(index).price,
    total_period: 31,
    update_date: Date.parse('2021-12-1'),
    next_update_date: date,
    subscription_id: Subscription.find(index).id
  )
  index += 1
end

index = 16
date = Date.parse('2021-12-21').next_year.beginning_of_month
10.times do |i|
  date = Date.parse('2021-12-21').next_year if i > 4 
  y_cons << ContractRenewal.new(
    renewal_count: 0,
    total_price: Subscription.find(index).price,
    total_period: 365,
    update_date: Date.parse('2021-12-1'),
    next_update_date: date,
    subscription_id: Subscription.find(index).id
  )
  index += 1
end

ContractRenewal.import d_cons
ContractRenewal.import m_cons
ContractRenewal.import y_cons
