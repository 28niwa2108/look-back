class ContractCancel < ApplicationRecord
  # アソシエーション
  belongs_to :subscription

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :reason

  # バリデーション
  with_options presence: true do
    validates :cancel_date
    validates :reason_id, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 6,
      message: 'を選択してください'
    }
  end
  validates :cancel_comment, length: { maximum: 300 }
end
