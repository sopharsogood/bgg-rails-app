class BoardgameGenre < ApplicationRecord
    belongs_to :boardgame
    belongs_to :genre
end
