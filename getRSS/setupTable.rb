require 'rss/2.0'
require 'open-uri'
require 'pg'

conn = PGconn.open("dbname=d5do5eebiebbrt host=ec2-107-22-169-108.compute-1.amazonaws.com user=irgffdctcevjds password=akxBZ5CEfIbGgytAF2L9YfQo_E port=5432 sslmode=require")

#res = conn.exec('CREATE TABLE articles (title VARCHAR(150), description VARCHAR(500), link VARCHAR(300));')
res = conn.exec('SELECT title FROM articles')

res.each do |row|
	row.each do |column|
		puts column
	end
end
		
#puts res

#feed.items.each do |item|
#	res = conn.exec('INSERT INTO articles(title, description, link) VALUES (\'' + item.title + '\',\'' + item.description + '\',\'' + item.link + '\');')

# puts item.title
# puts " (#{item.link})"
#  puts
#  puts item.description
#end


