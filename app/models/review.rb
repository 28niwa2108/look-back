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

  def self.get_ave_rate(reviews)
    review_sum = 0
    action_sum = 0
    review_count = 0
    action_count = 0

    reviews.each do |review|
      unless review.review_rate.nil?
        review_sum += review.review_rate
        review_count += 1
      end

      action = review.action_plan
      unless action.action_rate.nil?
        action_sum += action.action_rate
        action_count += 1
      end
    end
    review_ave = (review_sum / review_count).round if review_count != 0
    action_ave = (action_sum / action_count).round if action_count != 0
    { review_ave: review_ave, action_ave: action_ave }
  end
end
