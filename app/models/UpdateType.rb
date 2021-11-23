class UpdateType < ActiveHash::Base
  self.data = [
    { id: 0, name: '--' },
    { id: 1, name: '日' },
    { id: 2, name: '月' },
    { id: 3, name: '年' }
  ]
  has_many: subscriptions
end