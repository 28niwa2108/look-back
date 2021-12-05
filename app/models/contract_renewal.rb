class ContractRenewal < ApplicationRecord
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

  belongs_to :subscription
end
