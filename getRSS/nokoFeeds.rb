require 'open-uri'
require 'pg'
require 'nokogiri'

conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")

rss_content = ""
rss_feed = "http://yaledailynews.com/feed/"

doc = Nokogiri::XML(open(rss_feed)) #do |config|
	#config.options = Nokogiri::XML::ParseOptions.STRICT

source = doc.xpath("//rss/channel/title").first.text
puts source

doc.remove_namespaces!

#puts doc
search = doc.css('item')

if !search.empty?
		search.each do |data|
			title=data.at("title").text
			description=data.at("description").text
			link=data.at("link").text
			pubDate=data.at("pubDate").text
			content=data.at("encoded").text
			query = "INSERT INTO rss_articles(title, description, link, source, pubDate, content) VALUES (\'#{title}\',\'#{description}\',\'#{link}\',\'#{source}\',\'#{pubDate}\',\'#{content}\');"
			res = conn.exec(query)
				#puts "title: #{ title } link: #{ link }"
		end
end


#doc.xpath("//rss/channel/item").each do |item|

	#puts item.css('title').text()
	#puts item.css('description').text()
	#puts item.css('link').text()
	#r = item.at("content").text()
#feed = Feedzirra::Feed.fetch_and_parse(rss_feed)

#puts "#{feed.channel.title}"

#puts feed

#feed.entries.each do |item|
#	tempdate = item.published.to_s
	#puts tempdate
	#puts item.title, item.summary
#	puts item.description, item.url
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
