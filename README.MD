Instructions for running:


set environment variables to your twilio auth

change the 'from' variable on line 28 of web.rb a valid twilio number sms number

all other keys are exposed. Please don't take muh keys!

run in terminal: 

  $ ruby web.rb
  
  $ ngrok http 4567
  
  
Set up your twilio app to recieve sms in your twilio console 
  
from there, you can set the request url to process incoming messages. Mine looks like http://21b5aecc.ngrok.io/recieve_sms   
  
  
Text your twilio number anything and the app will ping you back with the 3 latest article headlines from ESPN's RSS feed, along with a shortened link and sentiment analysis.


You can get the gist of setting up your environnment here as well: https://www.twilio.com/docs/quickstart/ruby/sms#overviewhttps://www.twilio.com/docs/quickstart/ruby/sms#overview
