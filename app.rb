#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS
	Posts
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT, 
	 	create_date DATE, 
	 	content TEXT
	 )'

end

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

post '/new' do
	content = params[:content]
	if content.length <= 0
		@error = 'Type post text'
		return erb :new
	end
	@db.execute 'INSERT INTO Posts (content, create_date) values (?, datetime())', [content]
	erb "You tiped #{content}"
end
