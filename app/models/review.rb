class Review < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :subscription
  has_one :action_plan, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :later_check

  with_options presence: true do
    validates :start_date
    validates :end_date
    validates :later_check_id, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 2
    }
    validates :subscription_id
  end

  validates :review_comment, length: { maximum: 300 }
  validates :review_rate, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }, unless: :type_is_later

  def type_is_later
    later_check_id == 2
  end
end
