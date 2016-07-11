#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello!"
end

get '/contacts' do
	erb "Contacts!"
end

get '/new' do
	erb :new
end

get '/post' do
	erb "Posts"
end
