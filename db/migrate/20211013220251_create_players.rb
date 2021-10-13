class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date   :birthday
      t.integer :games_played, default: 0
      t.decimal :current_rank, :precision => 10, :scale => 2
      t.timestamps
    end
  end
end
