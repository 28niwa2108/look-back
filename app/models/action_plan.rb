class ActionPlan < ApplicationRecord
  with_options presence: true do
    validates :action_rate ,numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 5
    }
    validates :action_plan, length: { maximum: 300 }
  end
  validates :action_review_comment, length: { maximum: 300 }

  # アソシエーション
  belongs_to :review
end
