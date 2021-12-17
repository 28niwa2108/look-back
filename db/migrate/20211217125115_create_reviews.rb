class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.float      :review_rate,    null: false
      t.text       :review_comment
      t.references :subscription,   null: false, foreign_key: true
      t.timestamps
    end
  end
end
