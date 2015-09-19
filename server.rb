require 'sinatra'
require 'rubygems'
require 'oauth'
require 'json'
require 'indico'
require_relative 'keys'
require_relative 'config'
require 'pry'

Indico.api_key = $INDICO_KEY

get '/' do
  erb :index
end

get '/tweets' do
  username = params[:user_search]
  tweets = get_tweets(username)
  user_info = get_user_info(username)
  pos = []
  tweets.each do |tweet|
    pos << Indico.sentiment(tweet["text"])
  end
  pos_analysis = pos.reduce(:+) / pos.length
  erb :show, locals: { tweets: tweets, user_info: user_info, pos_analysis: pos_analysis }
end
