require "pp"
require "curb"
require "sequel"

`mkdir -p ../thumbs`

DB = Sequel.connect('mysql2://root@localhost/500px')

DB[:photos].each do |photo|
  filename = "../thumbs/#{photo[:id]}.jpeg"
  Curl::Easy.download(photo[:thumb_url], filename) unless File.exist? filename
end
