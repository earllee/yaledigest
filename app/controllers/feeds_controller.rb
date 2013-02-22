require 'rss/2.0'
require 'open-uri'
require 'pg'

class FeedsController < ApplicationController
  def home
	conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")
	res = conn.exec('select * from (select * from rss_articles2 as orig order by pubDate desc limit 45) as neww order by randid asc;')
	#	res = conn.exec('SELECT * FROM rss_articles')
	@titles = res.column_values(0)
	@articles = res
  end

  def discover
	conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")
	res = conn.exec('select * from (select * from otherpublications as orig order by pubDate desc limit 45) as neww order by randid asc;')
	#	res = conn.exec('SELECT * FROM rss_articles')
	@titles = res.column_values(0)
	@articles = res
  end
  
  def test
  	conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")
	res = conn.exec('SELECT title FROM articles')
	@titles = res.column_values(0)
  end
end
