class Review < ApplicationRecord
  # アソシエーション
  belongs_to :subscription
  has_one :action_plan, dependent: :destroy
end
