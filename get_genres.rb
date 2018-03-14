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
    return string.downcase()
end

def get_genres(movie_id, c)
  if c[movie_id] == nil
    begin
      retries ||= 0
      genres = Imdb::get(id: movie_id).genres
    rescue
      p "ops!!!! RETRY"
      retry if (retries += 1) < 3
    end
    # g << genres if not g.include? genres
    # g.flatten!
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
# g = []

# review_path = "raw_data/train/pos/"
# Dir.glob(review_path + "*").sort.each do |f|
#   filename = File.basename(f, File.extname(f))
#   url = a[filename.to_i]
#   p ("get genres for movie_id: " + filename)
#   movie_id = (/tt\d{7}/.match url)[0]
#   p ("the imdb_id is: " + movie_id.to_s)
#   types = get_genres(movie_id, c, g)
#   p ("the types are: " + types.to_s)
#   types&.each do |type|
#     file_path = "raw_data/train/positive/" + type.to_s
#     file = File.open(file_path, "a")
#     review_text = File.open(f).read
#     review_text = clean_str(review_text)
#     file.write review_text
#     file.write "\n\n"
#     file.close
#   end
# end
def generate_movie_genres(review_path, out_path, a, c)
  Dir.glob(review_path + "*").sort.each do |f|
    filename = File.basename(f, File.extname(f))
    url = a[filename.to_i]
    p ("get genres for movie_id: " + filename)
    movie_id = (/tt\d{7}/.match url)[0]
    p ("the imdb_id is: " + movie_id.to_s)
    types = get_genres(movie_id, c)
    p ("the types are: " + types.to_s)
    types&.each do |type|
      file_path = out_path + type.to_s
      file = File.open(file_path, "a")
      review_text = File.open(f).read
      review_text = clean_str(review_text)
      file.write review_text
      file.write "\n\n"
      file.close
    end
  end
end

review_path = "raw_data/train/neg/"
out_path = "raw_data/train/negative/"
generate_movie_genres(review_path, out_path, a, c)


review_path = "raw_data/test/neg/"
out_path = "raw_data/test/negative/"
generate_movie_genres(review_path, out_path, a, c)

review_path = "raw_data/test/pos/"
out_path = "raw_data/test/positive/"
generate_movie_genres(review_path, out_path, a, c)



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