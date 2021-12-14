class CreateContractRenewals < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_renewals do |t|
      t.integer    :renewal_count,    null: false
      t.integer    :total_price,      null: false
      t.integer    :total_period,     null: false
      t.date       :next_update_date, null: false
      t.references :subscription,     null: false, foreign_key: true
      t.timestamps
    end
  end
end
