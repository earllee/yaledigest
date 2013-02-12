require 'rss/2.0'
require 'open-uri'
require 'pg'

#conn = PGconn.open(:dbname => 'test')

url = 'http://www.oreillynet.com/pub/feed/1?format=rss2'
feed = RSS::Parser.parse(open(url).read, false)
#puts "#{feed.channel.title}"

feed.items.each do |item|
	#res = conn.exec('INSERT INTO articles(title, description, link) VALUES (\'' + item.title + '\',\'' + item.description + '\',\'' + item.link + '\');')

  puts item.title
  puts " (#{item.link})"
  puts
  puts item.description
end
