require 'sinatra'
require 'twitter'
require 'json'

get '/' do
    "Hello from Sinatra on Heroku!"
end

get '/tweets' do
    content_type :json
    tweets = Twitter::Search.new.hashtag("memtech").fetch

    output = { timestamp:   Time.now,
               tweets:      JSON.generate(tweets) }
end
    
