class CreateUserRoomRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :user_room_relationships do |t|
      t.integer :user_id
      t.integer :room_id
      t.string :name
    end
  end
end
