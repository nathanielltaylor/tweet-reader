require 'sinatra'
require 'rubygems'
require 'oauth'
require 'json'
require_relative 'config'

get '/' do
  erb :index
end

get '/tweets' do
  username = params[:user_search]
  tweets = get_tweets(username)
  user_info = get_user_info(username)
  erb :show, locals: { tweets: tweets, user_info: user_info }
end
