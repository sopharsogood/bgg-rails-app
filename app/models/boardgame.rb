class Boardgame < ApplicationRecord
    has_many :boardgame_genres
    has_many :genres, through: :boardgame_genres
end
