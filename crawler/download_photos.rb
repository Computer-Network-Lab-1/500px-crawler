require "pp"
require "sequel"

`mkdir -p ../thumbs`

DB = Sequel.connect('mysql2://root@localhost/500px')

DB[:photos].each do |photo|
  filename = "../thumbs/#{photo[:id]}.jpeg"
  `wget #{photo[:thumb_url]} -O #{filename} -q` unless File.exist? filename
end
