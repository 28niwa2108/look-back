class Review < ApplicationRecord
  # アソシエーション
  belongs_to :subscription
  has_one :action_plan, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :later_check
end
