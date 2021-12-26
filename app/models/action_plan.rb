class ActionPlan < ApplicationRecord
  # アソシエーション
  belongs_to :review

  validates :action_plan, length: { maximum: 300 }
  validates :action_review_comment, length: { maximum: 300 }

  validates :action_rate, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }, unless: :review_type_is_later

  validates :action_plan, presence: true, unless: :review_type_is_later

  def review_type_is_later
    self.review.later_check_id  == 2
  end
end
