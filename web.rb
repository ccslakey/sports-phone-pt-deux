require 'rss'
require 'open-uri'
require 'sinatra'
require 'twilio-ruby'





def get_news
  twiml = ""
  url = 'http://www.rotoworld.com/rss/feed.aspx?sport=nfl&ftype=news&count=10&format=rss'
  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|
      twiml += "<Say voice='alice'> #{item.description}</Say>"
      twiml += "<Pause length='1'/>"
    end
  end

  puts twiml
  twiml
end

get "/" do
  content_type 'text/xml'
  "Ahoy, Twilio!"
end

post '/recieve_sms' do
  content_type 'text/xml'

  response = Twilio::TwiML::Response.new do |r|
    r.message 'Hello'

  end

end


post '/call' do
  content_type "text/xml"

  "<Response>
    <Say voice='alice'>
      Thanks for calling the Fantasy Football news line powered by Roto World and Twillio.
    </Say>
    <Pause length='1'/>
    #{get_news}
    <Say voice='alice'>Goodbye.</Say>
    </Response>"
end
