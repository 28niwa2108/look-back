class ReviewAction
  # フォームオブジェクトで扱う属性
  include ActiveModel::Model
  attr_accessor :review_rate,
                :review_comment,
                :start_date,
                :end_date,
                :later_check_id,
                :user_id,
                :subscription_id,
                :action_rate,
                :action_review_comment,
                :action_plan,
                :review_id

  # Reviewモデルバリデーション
  with_options presence: true do
    validates :start_date
    validates :end_date
    validates :later_check_id, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 2
    }
    validates :user_id
    validates :subscription_id
  end

  validates :review_comment, length: { maximum: 300 }
  validates :review_rate, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }, unless: :type_is_later

  # ActionPlanモデルバリデーション
  validates :action_plan, length: { maximum: 300 }
  validates :action_review_comment, length: { maximum: 300 }

  validates :action_rate, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }, unless: :type_is_later

  validates :action_plan, presence: true, unless: :type_is_later
  validates :review_id, presence: true

  def type_is_later
    later_check_id == '2'
  end

  def save
    review = Review.create!(
      review_rate: review_rate,
      review_comment: review_comment,
      start_date: start_date,
      end_date: end_date,
      later_check_id: later_check_id,
      user_id: user_id,
      subscription_id: subscription_id
    )
    ActionPlan.create!(
      action_rate: action_rate,
      action_review_comment: action_review_comment,
      action_plan: action_plan,
      review_id: review.id
    )
  end

  def update
    review = Review.find_by(id: review_id)
    review.update!(
      review_rate: review_rate,
      review_comment: review_comment,
      start_date: start_date,
      end_date: end_date,
      later_check_id: later_check_id,
      user_id: user_id,
      subscription_id: subscription_id
    )

    action = ActionPlan.find_by(review_id: review_id)
    action.update!(
      action_rate: action_rate,
      action_review_comment: action_review_comment,
      action_plan: action_plan,
      review_id: review_id
    )
  end
end
