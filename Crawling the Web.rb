require 'chilkat'

spider = Chilkat::CkSpider.new()

#  The Initialize method may be called with just the domain name,
#  such as "www.joelonsoftware.com" or a full URL.  If you pass only
#  the domain name, you must add URLs to the unspidered list by calling
#  AddUnspidered.  Otherwise, the URL you pass to Initialize is the 1st
#  URL in the unspidered list.
spider.Initialize("www.joelonsoftware.com")

spider.AddUnspidered("http://www.joelonsoftware.com/")

success = spider.CrawlNext()

for i in 0 .. spider.get_NumOutboundLinks() - 1
    print spider.getOutboundLink(i) + "\n";
end