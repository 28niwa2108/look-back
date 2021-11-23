class UpdateType < ActiveHash::Base
  self.data = [
    { id: 1, name: '日' },
    { id: 2, name: '月' },
    { id: 3, name: '年' }
  ]
  include ActiveHash::Associations
  has_many :subscriptions
end