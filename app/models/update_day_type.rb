class UpdateDayType < ActiveHash::Base
  self.data = [
    { id: 1, name: '1日更新' },
    { id: 2, name: '契約日更新' }
  ]
  include ActiveHash::Associations
  has_many :subscriptions
end
