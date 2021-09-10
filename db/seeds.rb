# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def scrape_index(url)
    uri = URI.open(url)
    doc_index = Nokogiri::HTML(uri)
    return doc_index.css("tr")
end

def make_boardgames_from_index(doc_tr)
    doc_tr.css("tr").each_with_index do |doc_row, index|     # add .drop1 after .css("tr") instead of doing index thing
                                                            # or each.with_index and pass in starting index of 1 
        if index > 0                                         # throwing out index 0 because it's the table header, not a row with a game
            name_cell = doc_row.css("td.collection_objectname")
            new_game_hash = {
                :name => name_cell.css("a.primary").text.strip,
                :blurb => name_cell.css("p.smallefont").text.strip, # smallefont (no R) is sic
                :url => name_cell.css("a.primary").attribute("href").value
            }
            Boardgame.create(new_game_hash)
        end
    end
end

def get_single_game_details(boardgame)
    game_id = boardgame.url.split("/")[2]
    url = "https://api.geekdo.com/xmlapi2/thing?id=" + game_id
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML(response.body)
    genre_array = self.collect_values_of_type(doc, "boardgamecategory")
    genre_array.each do |genre|
        current_genre = Genre.find_or_create_by(name: genre)
        BoardgameGenre.create(boardgame: boardgame, genre: current_genre)
    end
end

def self.collect_values_of_type(doc, type_value)
    doc.css("link[type=#{type_value}]").collect do |link_tag|
        link_tag.attribute("value").value
    end
end

Boardgame.destroy_all
Genre.destroy_all
BoardgameGenre.destroy_all

doc_tr = scrape_index("https://boardgamegeek.com/browse/boardgame")
make_boardgames_from_index(doc_tr)

Boardgame.all.each do |boardgame|
    get_single_game_details(boardgame)
end
