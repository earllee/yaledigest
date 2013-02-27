require 'open-uri'
require 'pg'
require 'nokogiri'
require 'action_controller'

#include ActionController::Base.helpers
#params[:text] = "[foo-bar]"
#puts Regexp.new(Regexp.escape(params[:text]))

conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")

#res = conn.exec('SELECT title FROM articles')
prng = Random.new(43531)

for i in 600..800
	randid = prng.rand.to_s
	curid = i.to_s
	res = conn.exec("UPDATE otherpublications SET randID=#{randid} where id=#{curid};")
end

#lll = res.column_values(0).shuffle

#lll.each do |a|
#	puts a
#end