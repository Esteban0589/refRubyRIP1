require 'chilkat'

spider = Chilkat::CkSpider.new()

#  The spider object crawls a single web site at a time.  As you'll see
#  in later examples, you can collect outbound links and use them to
#  crawl the web.  For now, we'll simply spider 10 pages of chilkatsoft.com
spider.Initialize("www.metrolyrics.com")

#  Add the 1st URL:
spider.AddUnspidered("http://www.metrolyrics.com/")

spider.AddMustMatchPattern("*-lyrics-*")
spider.AddAvoidPattern("*-lyrics.html")
spider.AddMustMatchPattern("*.html")
spider.AddAvoidPattern("*-discussions-*")

#  Begin crawling the site by calling CrawlNext repeatedly.

for i in 0 .. 500

    success = spider.CrawlNext()
    if (success == true)
        #  Show the URL of the page just spidered.
        print spider.lastUrl() + "\n";
        #  The HTML is available in the LastHtml property
    else
        #  Did we get an error or are there no more URLs to crawl?
        if (spider.get_NumUnspidered() == 0)
            print "No more URLs to spider" + "\n";
        else
            print spider.lastErrorText() + "\n";
        end

    end

    #  Sleep 1 second before spidering the next URL.
    spider.SleepMs(1)
end
