class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.integer :try1
      t.string :try2integer
      t.integer :number
      t.integer :game_id

      t.timestamps
    end
  end
end
