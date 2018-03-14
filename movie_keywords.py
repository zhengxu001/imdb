from nlp_rake import rake
import codecs
import datetime
import glob
import os

stoppath = 'SmartStoplist.txt'
rake_object = rake.Rake(stoppath, 4, 3, 5)
review_path = "/Users/zen/imdb/raw_data/train/positive/"
# files = glob.glob(review_path + "*")
# files = glob.glob("/Users/zen/imdb/raw_data/tarin/positive/*")
files = os.listdir(review_path)
for f in files:
  print(f)
  sample_file = codecs.open(review_path + f, 'r', 'UTF-8')
  text = sample_file.read()
  print("get keywords for movie type: " + f)
  print(str(datetime.datetime.now()))
  keywords = rake_object.run(text)
  print(str(datetime.datetime.now()))
  file_path = "/Users/zen/imdb/raw_data/train/positive_keywords/" + f
  file = codecs.open(file_path, 'a', 'UTF-8')
  for e in keywords:
     file.write(e[0])
     file.write("\n")
  file.close