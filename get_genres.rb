require 'imdb'


def clean_str(string)
    # string = string.gsub(/[^A-Za-z0-9(),!?\'\`]/, " ")
    # string = string.gsub(/[\'s]/, " \'s")
    # string = string.gsub(/[\'ve]/, " \'ve")
    # string = string.gsub(/[n\'t]/, " n\'t")
    # string = string.gsub(/[\'re]/, " \'re")
    # string = string.gsub(/[\'d]/, " \'d")
    # string = string.gsub(/[\'ll]/, " \'ll")
    # string = string.gsub(/[,]/, " , ")
    # string = string.gsub(/[!]/, " ! ")
    # string = string.gsub(/[\(]/, " \( ")
    # string = string.gsub(/[\)]/, " \) ")
    # string = string.gsub(/[\?]/, " \? ")
    # string = string.gsub(/[\s{2,}]/, " ")
    string = string.gsub("<br /><br />", "")
    # return string.downcase()
end

def get_genres(movie_id, c, g)
  if c[movie_id] == nil
    begin
      retries ||= 0
      genres = Imdb::get(id: movie_id).genres
    rescue
      retry if (retries += 1) < 3
    end
    g << genres if not g.include? genres
    g.flatten!
    c[movie_id] = genres
  end
  # p g.uniq
  return c[movie_id]
end

url_path = "raw_data/train/urls_pos.txt"

a = []
text=File.open(url_path).read
text.each_line do |line|
  a << line
end

c = {}
g = []
review_path = "raw_data/train/pos/"
Dir.glob(review_path + "*").sort.each do |f|
  filename = File.basename(f, File.extname(f))
  url = a[filename.to_i]
  p ("get genres for movie_id: " + filename)
  movie_id = (/tt\d{7}/.match url)[0]
  types = get_genres(movie_id, c, g)
  types.each do |type|
    file_path = "raw_data/train/positive/" + type.to_s
    file = File.open(file_path, "a")
    review_text = File.open(f).read
    review_text = clean_str(review_text)
    file.write review_text
    file.write "\n\n"
    file.close
  end
end



# folder_path = [
#   "raw_data/train/pos/",
#   "raw_data/train/neg/",
#   "raw_data/test/neg/",
#   "raw_data/test/pos/"]

# folder_path.each do |path|
#   json_file = File.new(path + "out", "w")
#   Dir.glob(path + "*").sort.each do |f|
#     filename = File.basename(f, File.extname(f))
#     new_name = filename.split("_")[0]
#     File.rename(f, path+new_name)
#   end
# end