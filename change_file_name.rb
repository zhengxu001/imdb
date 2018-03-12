folder_path = [
	"raw_data/train/neg/",
	"raw_data/test/neg/",
	"raw_data/test/pos/"]

folder_path.each do |path|
  Dir.glob(path + "*").sort.each do |f|
  	filename = File.basename(f, File.extname(f))
    new_name = filename.split("_")[0]
    File.rename(f, path+new_name)
  end
end