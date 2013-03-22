task :getarticles do

#!/usr/bin/env ruby
require 'open-uri'
require 'pg'
require 'nokogiri'
require 'action_controller'

#include ActionController::Base.helpers
#params[:text] = "[foo-bar]"
#puts Regexp.new(Regexp.escape(params[:text]))

updateall = true
starttime = Time.now
numarticles = 0
errors = ""

begin
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

	#USE THAT
	rss_feeds = [rss_ydn, rss_yherald, rss_yalenews, rss_ycc, rss_crosscampus, rss_yathletics]			#"http://news.yale.edu/news-rss"]

	#rss_feeds = [rss_epicurean, rss_globalist]
	#rss_feeds = [rss_lightandtruth, rss_newjournalatyale, rss_thepolitic, rss_econreview, rss_epicurean, rss_globalist, rss_jpublichealth, rss_jmedlaw, rss_yscientific, rss_yuglawreview, rss_rumpus]
	#note: don't use broad recognition or qmagazine

	#dbasetable = "otherpublications"
	dbasetable = "rss_articles2"
	#dbasetable = "rss_articles"

	rss_feeds.each do |rss_feed|
		begin
			doc = Nokogiri::XML(open(rss_feed["url"], :read_timeout=>5)) #do |config|
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
		rescue
			errmsg = "#{$!}"
			errors += "\n" + rss_feed["name"] + ":" + errmsg
		end		
				
	end

	#Note: removed yale record for now, requires extra clean up.
	rss_feeds2 = [rss_lightandtruth, rss_newjournalatyale, rss_thepolitic, rss_econreview, rss_epicurean, rss_globalist, rss_jpublichealth, rss_jmedlaw, rss_yscientific, rss_yuglawreview, rss_rumpus]
	dbasetable2 = "otherpublications"
begin
	if (updateall)
		rss_feeds2.each do |rss_feed|
		begin
			doc = Nokogiri::XML(open(rss_feed["url"], :read_timeout=>50)) #do |config|
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

						doesexist = conn.exec("select id from #{dbasetable2}  where link=\'#{link}\'");
						ncopies = doesexist.ntuples();
						
						if (ncopies == 0)
							query = "INSERT INTO #{dbasetable2}(title, description, link, source, pubDate, content,randid) VALUES (\'#{title}\',\'#{description}\',\'#{link}\',\'#{source}\',\'#{pubDate}\',\'#{content}\', #{randid});"
							res = conn.exec(query)
							#puts "title: #{ title } link: #{ link }"
						end
					end
			end
		rescue
			errmsg = "#{$!}"
			errors += "\n" + rss_feed["name"] + ":" + errmsg
		end
		end
		
	end
end
	
endtime = Time.now
timedif = endtime - starttime

begin
	res = conn.exec('SELECT pubDate, link FROM rss_articles2 WHERE pubdate_s IS NULL')

	res.each do |row|
		begin
			d = Date.strptime(row["pubdate"], "%Y-%m-%d").strftime("%b %e, %Y")
			thelink = row["link"]
			#puts thelink
			#puts d
			temp = conn.exec("UPDATE rss_articles2 SET pubdate_s=\'#{d}\' WHERE LINK=\'#{thelink}\'")
		rescue
			errmsg = "date: #{thelink}"
			errors += ";" + errmsg;
		end
	end

	res2 = conn.exec('SELECT pubDate, link FROM otherpublications WHERE pubdate_s IS NULL')

	res2.each do |row|
		begin
			dd = Date.strptime(row["pubdate"], "%Y-%m-%d").strftime("%b %e, %Y")
			thelink2 = row["link"]
			#puts thelink
			#puts d
			temp2 = conn.exec("UPDATE otherpublications SET pubdate_s=\'#{dd}\' WHERE LINK=\'#{thelink2}\'")
		rescue
			errmsg = "date: #{thelink2}"
			errors += ";" + errmsg
		end
	end

	query = "INSERT INTO updatelog(thedate, runtime, numarticles, fullupdate, errors) VALUES (\'#{endtime}\',\'#{timedif}\',\'#{numarticles}\',\'#{updateall}\',\'#{errors}\');"
	res = conn.exec(query)
end
ensure
	conn.close()


end
end