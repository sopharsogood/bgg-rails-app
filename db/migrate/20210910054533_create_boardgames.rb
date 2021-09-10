class CreateBoardgames < ActiveRecord::Migration[6.1]
  def change
    create_table :boardgames do |t|
      t.string :name
      t.string :blurb
      t.string :url

      t.timestamps
    end
  end
end
