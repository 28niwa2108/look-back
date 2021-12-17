class Review < ApplicationRecord
  validates :review_rate, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }
  validates :text, length: { maximum: 300 }

  # アソシエーション
  belongs_to :subscription
end
