
require 'json'
require 'imdb'
genres = Imdb::get(id: "tt0077869").genres
p genres
# url_path = "raw_data/train/pos/out"
# text=File.open(url_path).read
# data_hash = JSON.parse(text)
# p data_hash.keys

# p data_hash["drama"]
# a = []
# text=File.open(url_path).read
# text.each_line do |line|
#   a << line
# end
# p a.uniq.size