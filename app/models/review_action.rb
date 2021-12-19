class ReviewAction
  # フォームオブジェクトで扱う属性
  include ActiveModel::Model
  attr_accessor :review_rate,
                :review_comment,
                :subscription_id,
                :action_rate,
                :action_review_comment,
                :action_plan,
                :review_id

  # Reviewモデルバリデーション
  validates :review_rate, presence: true, numericality: {
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }
  validates :review_comment, length: { maximum: 300 }
  validates :subscription_id, presence: true

  # ActionPlanモデルバリデーション
  with_options presence: true do
    validates :action_rate ,numericality: {
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5
    }
    validates :action_plan, length: { maximum: 300 }
  end
  validates :action_review_comment, length: { maximum: 300 }
  validates :review_id, presence: true

  def save
  end
end