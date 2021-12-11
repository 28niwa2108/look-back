class ContractRenewal < ApplicationRecord
  #バリデーション
  with_options presence: true do
    validates :renewal_count, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }
    validates :total_price, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }
    validates :total_period, numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0
    }
    validates :next_update_date
  end

  #アソシエーション
  belongs_to :subscription

  #----- 合計契約期間を取得するメソッド--------------------------
  def get_total_period(start_date, end_date)
    (end_date - start_date).to_i
  end
  #---------------------------------------------------------

  #----- 次回契約更新日を取得するメソッド(update_type_id別) -----
  def get_update_date(sub, next_update_date)
    case sub.update_type_id
    #「日」更新の場合
    when 1
      next_update_date + sub.update_cycle
    #「月」更新の場合
    when 2
      next_date = next_update_date
      sub.update_cycle.times do
        next_date = next_date.next_month
      end
      # -更新日タイプ別の処理
      day_type_diagnose(sub, next_date)
    #「年」更新の場合
    when 3
      next_date = next_update_date
      sub.update_cycle.times do
        next_date = next_date.next_year
      end
      # -更新日タイプ別の処理
      day_type_diagnose(sub, next_date)
    end
  end

  #次回契約更新日を取得するメソッド(update_day_type_id別)
  def day_type_diagnose(sub, next_date)
    #「1日更新」の場合
    if sub.update_day_type_id == 1
      next_date.beginning_of_month
    #「契約日更新の場合」
    else
      next_date
    end
  end
  #----------------------------------------------------------
end
