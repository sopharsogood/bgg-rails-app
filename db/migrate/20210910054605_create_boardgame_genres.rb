class CreateBoardgameGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :boardgame_genres do |t|
      t.integer :boardgame_id
      t.integer :genre_id

      t.timestamps
    end
  end
end
