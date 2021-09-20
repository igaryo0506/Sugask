class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :room_id
      t.string :name
      t.boolean :is_done
      t.text :content
      t.timestamps null: false
    end
  end
end
