class CreateContractCancels < ActiveRecord::Migration[6.0]
  def change
    create_table :contract_cancels do |t|
      t.date       :cancel_date,    null: false
      t.integer    :reason_id,      null: false
      t.text       :cancel_comment
      t.references :subscription,   null: false, foreign_key: true
      t.timestamps
    end
  end
end
