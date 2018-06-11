# server.rb
require 'sinatra'
require 'mongoid'

require_relative '../model/invoice'

Mongoid.load! 'mongoid.config'

get '/list' do
  Invoice.all.to_json
end