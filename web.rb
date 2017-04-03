require 'nokogiri'
require 'rss'
require 'open-uri'
require 'net/http'
require 'uri'
require 'json'
require 'sinatra'
require 'twilio-ruby'
require 'pry'


Twilio.configure do |config|
  config.account_sid = ENV["TWILIO_ACCOUNT_SID"]
  config.auth_token  = ENV["TWILIO_AUTH_TOKEN"]
end


def get_news(type = "espn")
  url = "http://www.espn.com/espn/rss/#{type}news"
  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
  end
end

def send_sms(phone_number, alert_message, image_url)
    client = Twilio::REST::Client.new
    client.messages.create(
      from:      '2027385787',
      to:        phone_number,
      body:      alert_message,
      media_url: image_url
    )
end

def shorten_url longUrl
  uri = URI.parse("https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyCyK-PZ_8eFKG68YBtEy5ztl6zraEr6Crs")
  headers = { "Content-Type" => "application/json" }
  # organize headers, https, request call
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(uri.request_uri, headers)
  request.body = { 'longUrl' => longUrl }.to_json

  # Send the request
  response = http.request(request)

  res = JSON.parse response.body
  # return shortened goo.gl url
  res['id']
end


def scrape_espn_article url
  doc = Nokogiri::HTML(open url)
  article = doc.css '.article-body p'
  a = Array article
  text = String a.map { |item| item.text }.reduce(:+)
end

def get_sentiment text
  begin
    url = URI.parse(URI.escape("https://api.havenondemand.com/1/api/sync/analyzesentiment/v2?apikey=f5c4cfa1-6b5f-4695-a2a5-c37504a5c27c&text=#{text}"))
    # binding.pry
    response = JSON.parse(Net::HTTP.get url)
    # binding.pry
    response['sentiment_analysis'][0]['aggregate']
  rescue
    # binding.pry 
    { 'sentiment' => "Couldn't find score or sentiment", 'score' => 0 }
  end

end



get '/' do
  "Ahoy, Twilio!"
end


post '/recieve_sms' do
  content_type 'text/xml'
  feed = get_news 'nfl/'

  response = Twilio::TwiML::Response.new do |r|
    headlines = ""
    feed.items.take(3).each do |item|
      article = scrape_espn_article item.link
      sentiment = get_sentiment article.dump
      # binding.pry
      headlines += "#{item.title} - #{shorten_url item.link}. We think this article is #{sentiment['sentiment']}: #{(sentiment['score'] * 10)} \n \n"
      # binding.pry
    end
    # binding.pry
    r.message headlines
  end
  response.to_xml

end

post '/send_sms' do
  to = params["to"]
  message = params["body"]

  send_sms to, message
end
