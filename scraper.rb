require 'nokogiri'
require 'open-uri'
# doc = Nokogiri::HTML(open url)
# article = doc.css '.article-body p'


class ESPNScraper

  def initialize (url)
    @page = url
    # feed = get_news 'nfl/'
  end

end
