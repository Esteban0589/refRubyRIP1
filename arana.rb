require 'chilkat'
require 'rubygems'
require 'nokogiri'   
require 'open-uri'

spider = Chilkat::CkSpider.new()

#  The spider object crawls a single web site at a time.  As you'll see
#  in later examples, you can collect outbound links and use them to
#  crawl the web.  For now, we'll simply spider 10 pages of chilkatsoft.com
spider.Initialize("www.metrolyrics.com")

#  Add the 1st URL:
spider.AddUnspidered("http://www.metrolyrics.com/")

# spider.AddMustMatchPattern("*-lyrics-*")
# spider.AddAvoidPattern("*-lyrics.html")
# spider.AddAvoidPattern("*-discussions-*")
# spider.AddAvoidPattern("*news-story*")
# spider.AddAvoidPattern("*printlyric*")

#  Begin crawling the site by calling CrawlNext repeatedly.
output = File.open( "outputfile.txt","w" )
#Buscara en 1000paginas

i=0
while (i<3)

    success = spider.CrawlNext()
    if (success == true)
        #este if verificara que la url tenga el patron de las paginas con letra de canciones
        if(
            #el patron es nombre pag/nombrecancion-lyrics-autor.html
            (/(.*)-lyrics-(.*)/ =~ spider.lastUrl())&& 
            # (/(.*)(html$)/ =~ spider.lastUrl())&& #Este creo q va comentado porque creo q no importa que terminen en html.*
            #debe evitar los casos de abajop porque parecen cumplir el criterio pero no son paginas de letras de canciones.
            (/(.*)(discussions)(.*)/ !~ spider.lastUrl())&&
            (/(.*)(news-story)(.*)/ !~ spider.lastUrl())&&
            (/(.*)(news-gallery)(.*)/ !~ spider.lastUrl())&&
            (/(.*)(printlyric)(.*)/ !~ spider.lastUrl())
            )
            #  Show the URL of the page just spidered.
            i=i+1
            output << i
            output <<  "\n"
            
            output << spider.lastUrl() + "\n";

            autor = Nokogiri::HTML(spider.lastHtml()).css("h2").map {|h2| h2.content}
            output << autor[0].sub!(" Lyrics", "")
            
            titulo = Nokogiri::HTML(spider.lastHtml()).css("header h1").map {|header| header.content}
            output << titulo[0].sub!(" Lyrics", "") + "\n";
            
            # lyric = Nokogiri::HTML(spider.lastHtml()).css("div#lyrics-body-text").map {|div| div.content}
            # output << lyric[0] + "\n";
            lyric = Nokogiri::HTML(spider.lastHtml()).css("div#lyrics-body-text p.verse").map {|div| div.content}
            print (lyric.join("\n"))
            print "\n"
            print "\n"
           # lyric.sub!("\\n", "\n")
            
            output << (lyric.join("\n"))

            output <<  "\n"
            output <<  "\n"
            
            
            
            
        end
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
output.close
