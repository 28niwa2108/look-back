class Subscription < ApplicationRecord
  # バリデーション
  with_options presence: true do
    validates :name, length: { maximum: 10 }
    validates :price, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      message: 'は0以上の整数を入力してください'
    }
    validates :contract_date
    validates :update_cycle, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 31
    }
  end

  validates :update_type_id, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 3,
    message: 'は日・月・年のいずれかを選択してください'
  }

  validates :update_day_type_id, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 2,
  }, unless: :type_is_day

  # アソシエーション
  belongs_to :user
  has_one :contract_renewal, dependent: :destroy
  has_one :contract_cancel, dependent: :destroy
  has_many :reviews, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :update_type
  belongs_to :update_day_type

  # メソッド
  def type_is_day
    update_type_id == 1
  end

  def get_update_cycle_days(update_date)
    case update_type_id
    when 1 # 日
      update_date - update_cycle
    when 2 # 月
      update_cycle.times do
        update_date = update_date.last_month
      end
      update_date
    when 3 # 年
      update_cycle.times do
        update_date = update_date.last_year
      end
      update_date
    end
  end
end
