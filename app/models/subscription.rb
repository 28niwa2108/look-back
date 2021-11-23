class Subscription < ApplicationRecord
  with_options presence: true do
    validates :name, length: { maximum: 10 }
    validates :price, numericality: { only_integer: true }
    validates :contact_date
    validates :update_cycle, numericality: { only_integer: true }
  end
  validates :update_type_id, numericality: {other_than: 0 }

  belongs_to :user
  belongs_to :update_type
end
