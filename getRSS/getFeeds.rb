require 'feedzirra'
require 'open-uri'
require 'pg'

conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")



rss_content = ""
rss_feed = "http://yaledailynews.com/feed/"

feed = Feedzirra::Feed.fetch_and_parse(rss_feed)

#puts "#{feed.channel.title}"

puts feed

feed.entries.each do |item|
	tempdate = item.published.to_s
	#puts tempdate
	#puts item.title, item.summary
	puts item.description, item.url
	#puts "(\'INSERT INTO rss_articles(title, description, link, source, pubDate, content) VALUES (\'#{item.title.encode('UTF-8').sanitize}\',\'#{item.summary.encode('UTF-8').sanitize}\',\'#{item.url}\',\'#{feed.title.encode('UTF-8').sanitize}\',\'#{tempdate}\',\'#{item.content.sanitize}\');\')"
	#tempdate = "asdf"
	#res = conn.exec('INSERT INTO rss_articles(title, description, link, source, pubDate, content) VALUES (\'' + item.title + '\',\'' + item.summary + '\',\'' + item.url + '\',\'' + feed.title + '\', \'' + tempdate + '\',\'' + item.content  + '\');')

	#	res = conn.exec('INSERT INTO rss_articles(title, description, link, source, pubDate, content) VALUES (\'' + item.title + '\',\'' + item.summary + '\',\'' + item.url + '\',\'' + feed.title + '\', \'' + tempdate + '\',\'' + item.content  + '\');')
#	puts "(\'INSERT INTO rss_articles(title, description, link, source, pubDate, content) VALUES (\'#{item.title.encode('UTF-8').sanitize}\',\'#{item.summary.encode('UTF-8').sanitize}\',\'#{item.url}\',\'#{feed.title.encode('UTF-8').sanitize}\',\'#{tempdate}\',\'#{item.content.sanitize}\');\')"

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
