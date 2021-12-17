class Review < ApplicationRecord
  validates :review_rate, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }
  validates :review_comment, length: { maximum: 300 }

  # アソシエーション
  belongs_to :subscription
  has_one :action_plan
end
