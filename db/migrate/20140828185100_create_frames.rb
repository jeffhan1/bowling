class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.integer :try1
      t.integer :try2
      t.integer :number
      t.integer :player_id
      t.boolean :completed

      t.timestamps
    end
  end
end
