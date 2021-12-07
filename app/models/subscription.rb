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

  validates :update_day_type_id, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 2
  }, unless: :type_is_day

  belongs_to :user
  has_one :contract_renewal

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :update_type
  belongs_to :update_day_type

  def type_is_day
    self.update_type_id == 1
  end
end
