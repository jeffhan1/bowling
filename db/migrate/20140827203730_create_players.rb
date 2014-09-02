class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :score
      t.integer :played
      t.integer :match_id
      t.integer :bonus

      t.timestamps
    end
  end
end
