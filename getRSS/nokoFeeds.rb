require 'open-uri'
require 'pg'
require 'nokogiri'
require 'action_controller'

#include ActionController::Base.helpers
#params[:text] = "[foo-bar]"
#puts Regexp.new(Regexp.escape(params[:text]))

conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")

#standard feeds
rss_content = ""
rss_ydn = "http://yaledailynews.com/feed/"
rss_yherald = "http://yaleherald.com/feed/"
rss_yalenews = "http://news.yale.edu/news-rss"
rss_yathletics = "http://www.yalebulldogs.com/landing/headlines-featured?feed=rss_2.0"
rss_ycc = "http://ycc.yale.edu/feed"

rss_yrecord = "http://www.yalerecord.com/feed/"

#non-yale general news feeds
rss_nhregister = "http://www.nhregister.com/?rss=news"
rss_nytimes = "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
rss_bbc = "http://feeds.bbci.co.uk/news/rss.xml"


#yale publications (not news)
rss_broadrecognition = "http://www.broadrecognition.com/feed" #updated feb 18
rss_lightandtruth = "http://lightandtruthonline.wordpress.com/feed/" #updated dec 2012
rss_logos = "http://yalelogos.com/feed/" #updated feb 15
rss_newjournalatyale = "http://www.thenewjournalatyale.com/feed/" #updated dec 2012
rss_thepolitic = "http://thepolitic.org/feed/" #updated feb 21
rss_qmagazine = "http://www.qmagazineatyale.com/feed/" #updated feb 14
rss_econreview = "http://yaleeconomicreview.com/feed/" #updated feb 20
rss_epicurean = "http://yaleepicurean.com/feed/" #updated feb 18
rss_globalist = "http://tyglobalist.org/feed/" #updated feb 21
rss_jpublichealth = "http://theyaleph.com/feed" #updated feb 20
rss_jmedlaw = "http://www.yalemedlaw.org/feed/" #updated feb 22
rss_yscientific = "http://www.yalescientific.org/feed/" #updated feb 21
rss_yuglawreview = "http://yulr.org/feed/" #updated feb 1

#notes: logos doesn't work (atom in link)

#rss_feeds = [rss_feed1, rss_feed2]
rss_feeds = [rss_ydn, rss_yherald, rss_yalenews, rss_ycc]			#"http://news.yale.edu/news-rss"]

#rss_feeds = [rss_broadrecognition, rss_lightandtruth, rss_newjournalatyale, rss_thepolitic, rss_qmagazine, rss_econreview, rss_epicurean, rss_globalist, rss_jpublichealth, rss_jmedlaw, rss_yscientific, rss_yuglawreview]

#dbasetable = "otherpublications"
dbasetable = "rss_articles2"
#dbasetable = "rss_articles"

rss_feeds.each do |rss_feed|
doc = Nokogiri::XML(open(rss_feed)) #do |config|
	#config.options = Nokogiri::XML::ParseOptions.STRICT

source = doc.xpath("//rss/channel/title").first.text.gsub("'", "\\\\'")
puts ''
puts source

doc.remove_namespaces!

#puts doc
search = doc.css('item')

if !search.empty?
		search.each do |data|
			next if (!(data.at("title")) || !(data.at("description")) || !(data.at("link")) || !(data.at("pubDate")))
			
			title=(ActionController::Base.helpers.sanitize(data.at("title").text.force_encoding("UTF-8"))).gsub("'", "\\\\'")

			description=ActionController::Base.helpers.sanitize(data.at("description").text.force_encoding("UTF-8")).gsub("'", "\\\\'")
			#puts description
			
			link=data.at("link").text.force_encoding("UTF-8")
			pubDate=data.at("pubDate").text

			if (data.at("encoded")) then
				content=data.at("encoded").text.gsub("'", "\\\\'")
			else
				content=''
			end
		#puts "#{title}"
			query = "INSERT INTO #{dbasetable}(title, description, link, source, pubDate, content) VALUES (\'#{title}\',\'#{description}\',\'#{link}\',\'#{source}\',\'#{pubDate}\',\'#{content}\');"
			res = conn.exec(query)
				#puts "title: #{ title } link: #{ link }"
		end
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
#end
