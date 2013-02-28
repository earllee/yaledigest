require 'open-uri'
require 'pg'
require 'nokogiri'
require 'action_controller'

#include ActionController::Base.helpers
#params[:text] = "[foo-bar]"
#puts Regexp.new(Regexp.escape(params[:text]))

conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")

rfeed = Struct.new(:url, :name)



#standard feeds
rss_content = ""
rss_ydn = rfeed.new("http://yaledailynews.com/feed/", "Yale Daily News")
rss_yherald = rfeed.new("http://yaleherald.com/feed/", "Yale Herald")
rss_yalenews = rfeed.new("http://news.yale.edu/news-rss", "YaleNews")
rss_yathletics = rfeed.new("http://www.yalebulldogs.com/landing/headlines-featured?feed=rss_2.0", "Bulldog Sports")
rss_ycc = rfeed.new("http://ycc.yale.edu/feed", "Yale College Council")

rss_yrecord = rfeed.new("http://www.yalerecord.com/feed/", "Yale Record")

#non-yale general news feeds
rss_nhregister = "http://www.nhregister.com/?rss=news"
rss_nytimes = "http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
rss_bbc = "http://feeds.bbci.co.uk/news/rss.xml"


#yale publications (not news)
rss_broadrecognition = "http://www.broadrecognition.com/feed" #updated feb 18
rss_qmagazine = "http://www.qmagazineatyale.com/feed/" #updated feb 14

rss_crosscampus = rfeed.new("http://yaledailynews.com/crosscampus/feed/", "Yale Daily News")

rss_lightandtruth = rfeed.new("http://lightandtruthonline.wordpress.com/feed/","Light and Truth Online") #updated dec 2012
rss_logos = rfeed.new("http://yalelogos.com/feed/","Yale Logos") #updated feb 15
rss_newjournalatyale = rfeed.new("http://www.thenewjournalatyale.com/feed/", "The New Journal at Yale") #updated dec 2012
rss_thepolitic = rfeed.new("http://thepolitic.org/feed/","The Politic") #updated feb 21
rss_econreview = rfeed.new("http://yaleeconomicreview.com/feed/", "Yale Economic Review") #updated feb 20
rss_epicurean = rfeed.new("http://yaleepicurean.com/feed/","Yale Epicurean") #updated feb 18
rss_globalist = rfeed.new("http://tyglobalist.org/feed/","The Globalist") #updated feb 21
rss_jpublichealth = rfeed.new("http://theyaleph.com/feed", "The Yale Journal of PH") #updated feb 20
rss_jmedlaw = rfeed.new("http://www.yalemedlaw.org/feed/", "Yale Journal of Medicine and Law") #updated feb 22
rss_yscientific = rfeed.new("http://www.yalescientific.org/feed/","Yale Scientific") #updated feb 21
rss_yuglawreview = rfeed.new("http://yulr.org/feed/", "Yale UG Law Review") #updated feb 1

rss_rumpus = rfeed.new("http://www.yalerumpus.com/feed/", "Yale Rumpus")


rss_yalefml = rfeed.new("http://yalefml.tumblr.com/rss", "YaleFML")


#notes: logos doesn't work (atom in link)


rss_feeds = [rss_ydn, rss_yherald, rss_yalenews, rss_ycc, rss_crosscampus, rss_yathletics]			#"http://news.yale.edu/news-rss"]

#rss_feeds = [rss_lightandtruth, rss_newjournalatyale, rss_thepolitic, rss_econreview, rss_epicurean, rss_globalist, rss_jpublichealth, rss_jmedlaw, rss_yscientific, rss_yuglawreview, rss_rumpus]
#note: don't use broad recognition or qmagazine

#dbasetable = "otherpublications"
dbasetable = "rss_articles2"
#dbasetable = "rss_articles"

rss_feeds.each do |rss_feed|
doc = Nokogiri::XML(open(rss_feed["url"])) #do |config|
	#config.options = Nokogiri::XML::ParseOptions.STRICT

source = rss_feed["name"]		#doc.xpath("//rss/channel/title").first.text.gsub("'", "\\\\'")
puts ''
puts source

doc.remove_namespaces!

#puts doc
search = doc.css('item')

prng = Random.new()

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
			randid = prng.rand.to_s

			doesexist = conn.exec("select id from #{dbasetable}  where link=\'#{link}\'");
			ncopies = doesexist.ntuples();
			
			if (ncopies == 0)
				query = "INSERT INTO #{dbasetable}(title, description, link, source, pubDate, content,randid) VALUES (\'#{title}\',\'#{description}\',\'#{link}\',\'#{source}\',\'#{pubDate}\',\'#{content}\', #{randid});"
				res = conn.exec(query)
				#puts "title: #{ title } link: #{ link }"
			end
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
