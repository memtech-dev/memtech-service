require 'sinatra'
require 'twitter'
require 'json'

get '/' do
    "Hello from Sinatra on Heroku!"
end

get '/tweets' do
    tweets = Twitter::Search.new.hashtag("memtech").fetch
    JSON.generate(tweets)
end
    
