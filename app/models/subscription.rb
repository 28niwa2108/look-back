class Subscription < ApplicationRecord
  with_options presence: true do
    validates :name, length: { maximum: 10 }
    validates :price, numericality: { only_integer: true }
    validates :contract_date
    validates :update_cycle, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 31
    }
  end
  validates :update_type_id, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 3
  }

  belongs_to :user

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :update_type
end
