class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string     :name,           null: false
      t.integer    :price,          null: false
      t.date       :contract_date,  null: false
      t.integer    :update_type_id, null: false
      t.integer    :update_cycle,   null: false
      t.references :user,           null: false, foreign_key: true
      t.timestamps
    end
  end
end
