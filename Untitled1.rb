require nokogiri

doc = Nokogiri::HTML( my_html_string )
img_srcs = doc.css('img').map{ |i| i['src'] } # Array of strings