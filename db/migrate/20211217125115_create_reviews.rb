class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer    :review_rate
      t.text       :review_comment
      t.date       :start_date,        null: false
      t.date       :end_date,          null: false
      t.integer    :later_check_id,    null: false
      t.references :subscription,      null: false, foreign_key: true
      t.timestamps
    end
  end
end
