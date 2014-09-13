require 'yaml'
require 'tweetstream'
require 'dino'
 
auth = YAML::load_file("twitter_api_config.yml")
 
TweetStream.configure do |config|
    config.consumer_key       = auth["consumer_key"]
    config.consumer_secret    = auth["consumer_secret"]
    config.oauth_token        = auth["oauth_token"]
    config.oauth_token_secret = auth["oauth_token_secret"]
end
 
board = Dino::Board.new(Dino::TxRx::Serial.new)
redled = Dino::Components::Led.new(pin: 13, board: board) # for negative sentiments
greenled = Dino::Components::Led.new(pin: 12, board: board) # for positive sentiments
 
#positive sentiments 
awesome = ['awesome','very good','happy', 'nice', ':-)' , ':)', 'super', 'crazy', 'good', 'fun', 'love']

#negative sentiments
awful = ['not good', 'bad', 'sad', 'not happy','not like', 'dislike', 'not good', ':(', ':-(', 'not fun', 'not good', 'not nice', 'hate', 'not fun']
 
 
TweetStream::Client.new.track("arsenal") do |status| # look for tweets that contain the word "arsenal". To add more keywords, just write TweetStream::Client.new.track("keyword1", "keyword2")
    puts status.text      # prints the tweet to screen.
    tweeet = status.text
    if awful.any? { |w| tweeet.include? w } # checks if the tweeet contains any word from the array 'awful' i.e. negative sentiments. If yes, red led goes on for 0.1 sec. If not, nothing happens.
      puts '**sad tweet**'
      redled.send(:on)
      sleep 0.1
      redled.send(:off)
      sleep 0.1
    elsif awesome.any? { |w| tweeet.include? w } # checks if the tweeet contains any word from the array 'awesome' i.e. positive sentiments. If yes, green led goes on for 0.1 sec. If not, nothing happens.
        puts '--happy tweet--'
        greenled.send(:on)
        sleep 0.1
        greenled.send(:off)
        sleep 0.1
    end
end