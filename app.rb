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

	@db.execute 'CREATE TABLE IF NOT EXISTS
	Comments
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
	 	create_date DATE, 
	 	content TEXT,
	 	post_id INTEGER
	 )'

end

get '/' do
	init_db
	@results = @db.execute 'SELECT * FROM Posts ORDER BY id DESC'
	erb :index
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
	user_name = params[:user_name]
	if content.length <= 0
		@error = 'Type post text'
		return erb :new
	end
	@db.execute 'INSERT INTO 
		Posts 
		(
			content, 
			create_date,
			user_name
		) 
		values 
		(
			?, 
			datetime(), 
			?
		)', [content, user_name]
	redirect to('/')
end

get '/details/:post_id' do

	post_id = params[:post_id]

	results = @db.execute 'SELECT * FROM Posts WHERE id=?', [post_id]
	@row = results[0]

	@comments = @db.execute 'SELECT * FROM Comments WHERE post_id=? ORDER BY id', [post_id]

	erb :details


end

post '/details/:post_id' do

	post_id = params[:post_id]
	content = params[:content]
	if content.length <= 0
		@error = 'Type post text'
		return erb :new
	end
	init_db
	@db.execute 'INSERT INTO 
		Comments (
			content, 
			create_date, 
			post_id) 
		values (
			?, 
			datetime(),
			?
		)', [content, post_id]

	redirect to("details/#{post_id}")
end
