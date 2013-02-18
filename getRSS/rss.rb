require 'rss/2.0'
require 'open-uri'
require 'pg'

conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")

#url = 'http://www.oreillynet.com/pub/feed/1?format=rss2'
#feed = RSS::Parser.parse(open(url).read, false)

rss_content = ""
rss_feed = "http://yaledailynews.com/feed/"

url = rss_feed
feed = RSS::Parser.parse(open(url).read, false)

#puts "#{feed.channel.title}"

puts feed

feed.items.each do |item|
	tempdate = "{item.date}"
	res = conn.exec('INSERT INTO rss_articles(title, description, link, source, pubDate, content) VALUES (\'' + item.title + '\',\'' + item.description + '\',\'' + item.link + '\',\'' + feed.channel.title + '\', \'' + tempdate + '\',\'' + item.content  + '\');')

  #puts item.title
  #puts " (#{item.link})"
  #puts
  #puts item.description
end







# Read the feed into rss_content
#open(rss_feed) do |f|
#   rss_content = f.read
#end


# Parse the feed, dumping its contents to rss
#rss = RSS::Parser.parse(rss_content, false)

# Output the feed title and website URL
#puts "Title: #{rss.channel.title}"
#puts "RSS URL: #{rss.channel.link}"
#puts "Total entries: #{rss.items.size}"
