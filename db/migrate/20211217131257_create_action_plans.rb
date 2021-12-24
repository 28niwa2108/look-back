class CreateActionPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :action_plans do |t|
      t.integer    :action_rate
      t.text       :action_review_comment
      t.text       :action_plan
      t.references :review,                null: false, foreign_key: true
      t.timestamps
    end
  end
end
