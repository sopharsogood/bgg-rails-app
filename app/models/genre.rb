class Genre < ApplicationRecord
    has_many :boardgame_genres
    has_many :boardgames, through: :boardgame_genres
end
