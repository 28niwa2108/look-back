class LaterCheck < ActiveHash::Base
  self.data = [
    { id: 1, name: '今スグ振り返る' },
    { id: 2, name: '後で振り返る' }
  ]
  include ActiveHash::Associations
  has_many :reviews
end
