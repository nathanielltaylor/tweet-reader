require 'sinatra'
require 'oauth'
require 'json'
require 'indico'
require 'sinatra/flash'
require_relative 'keys'
require_relative 'config'

Indico.api_key = $INDICO_KEY

enable :sessions

get '/' do
  erb :index
end

get '/tweets' do
  username = params[:user_search]
  tweets = get_tweets(username)
  if tweets == nil
    flash[:notice] = "Could not access tweets. Either an account of that name does not currently exist or its tweets are protected."
    redirect '/'
  end
  user_info = get_user_info(username)
  pos, pol, liberal, con, libertarian, green = Array.new(6) { [] }
  tweets.each do |tweet|
    pos << Indico.sentiment(tweet["text"])
    pol << Indico.political(tweet["text"])
  end
  pos_analysis = ((pos.reduce(:+) / pos.length) * 100).round(2)
  pol.each do |tweet_data|
    tweet_data.each do |k, v|
      if k == "Liberal"
        liberal << v
      elsif k == "Conservative"
        con << v
      elsif k == "Libertarian"
        libertarian << v
      elsif k == "Green"
        green << v
      end
    end
  end
    liberal_percent = ((liberal.reduce(:+) / liberal.length) * 100).round(2)
    con_percent = ((con.reduce(:+) / con.length) * 100).round(2)
    libertarian_percent = ((libertarian.reduce(:+) / libertarian.length) * 100).round(2)
    green_percent = ((green.reduce(:+) / green.length) * 100).round(2)
  erb :show, locals: {
    tweets: tweets,
    user_info: user_info,
    pos_analysis: pos_analysis,
    liberal_percent: liberal_percent,
    con_percent: con_percent,
    libertarian_percent: libertarian_percent,
    green_percent: green_percent }
end
