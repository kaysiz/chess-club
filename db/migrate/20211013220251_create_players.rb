class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date   :birthday
      t.integer :games_played, default: 0
      t.integer :current_rank, default: 1
      t.timestamps
    end
  end
end
