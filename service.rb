require 'sinatra'
require 'twitter'
require 'json'

get '/' do
    home_page = <<-HERE.gsub /^\s+/, ""
    <h1>Welcome to memtech-service!</h1>
    <p>
        Check out the project page on <a href="https://github.com/memtech-dev/memtech-service">github</a>.
    </p>
    <h3>API Features</h3>
    <ul>
        <li><a href="/tweets">#memtech tweets</a></li>
    </ul>
    HERE
end

get '/tweets' do
    content_type :json
    tweets = Twitter::Search.new.hashtag("memtech").fetch

    output = JSON.generate({
        timestamp:   Time.now,
        tweets:      tweets
    })
end
    
