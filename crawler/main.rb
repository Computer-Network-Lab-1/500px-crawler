require "pp"
require "curb"
require "json"
require "sequel"

DB = Sequel.connect('mysql2://root@localhost/500px')

(1..407).each do |page_id|
  http = Curl.get("https://api.500px.com/v1/photos?rpp=38&feature=popular&image_size%5B%5D=3&image_size%5B%5D=2048&page=#{page_id}&sort=&include_states=true&formats=jpeg%2Clytro&only=&authenticity_token=Vi17RNpoPqhVOuvbEL1iAFi05AcsvEF2HQKWLfEVsiY%3D&consumer_key=OC3h3kNgWFQMR2pyqKi38ddIa9DqG2JeFryjrRfF") do |http|
    http.cookies = "_hpx1=BAh7CUkiD3Nlc3Npb25faWQGOgZFVEkiJTM1Y2E0NTE0N2IzMDA3ZmU2NzZjMTNmNTFkMjdiODZmBjsAVEkiCWhvc3QGOwBGIhJhcGkuNTAwcHguY29tSSIQX2NzcmZfdG9rZW4GOwBGSSIxVmkxN1JOcG9QcWhWT3V2YkVMMWlBRmkwNUFjc3ZFRjJIUUtXTGZFVnNpWT0GOwBGSSIRcHJldmlvdXNfdXJsBjsARkkiFC9wb3B1bGFyP3BhZ2U9MgY7AFQ%3D--16aab7e3242af220980ab229d24d9682650d4699"
  end
  json = JSON.parse(http.body)
  json["photos"].each do |photo|
    photo_data = {
      id: photo["id"],
      user_id: photo["user_id"],
      name: photo["name"],
      description: photo["description"],
      rating: photo["rating"],
      created_at: photo["created_at"],
      taken_at: photo["taken_at"],
      width: photo["width"],
      height: photo["height"],
      thumb_url: photo["image_url"][0],
      image_url: photo["image_url"][1],
    }
    begin
      DB[:photos].insert(photo_data)
    rescue => e
      puts "#{e.class}: #{e}"
    end
  end
end
