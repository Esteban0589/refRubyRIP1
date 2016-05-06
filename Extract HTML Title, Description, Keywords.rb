require 'chilkat'

spider = Chilkat::CkSpider.new()

spider.Initialize("www.chilkatsoft.com")

robotsText = spider.fetchRobotsText()

print robotsText + "\n";