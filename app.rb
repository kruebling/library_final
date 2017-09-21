require 'sinatra'
require 'pry'
require 'sinatra/reloader'
also_reload'.lib/**/*.rb'
require './lib/author'
require './lib/book'
require './lib/patron'
# require './lib/author_info'
# require './lib/book_info'
# require './lib/patron_info'
# require './lib/library'
require 'pg'

DB = PG.connect({:dbname => "library"})

get('/') do

  erb(:index)
end

get('/library') do
  @books = Book.all()
  @authors = Author.all()
  erb(:library)
end


get('/authors') do
  @authors = Author.all()
  erb(:authors)
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

post("/authors") do
  name = params.fetch("name")
  author = Author.new({:name => name, :id => nil})
  author.save()
  @authors = Author.all()
  erb(:authors)
end

post("/books") do
  title = params.fetch("title")
  book = Book.new({:title => title, :id => nil})
  book.save()
  @books = Book.all()
  erb(:books)
end

get("/authors/:id") do
  @author = Author.find(params.fetch("id").to_i())
  @books = Book.all()
  erb(:author_info)
end

get("/books/:id") do
  @book = Book.find(params.fetch("id").to_i())
  @authors = Author.all()
  erb(:book_info)
end

patch("/authors/:id") do
  author_id = params.fetch("id").to_i()
  @author = Author.find(author_id)
  book_id = params.fetch("book_id")
  @author.update({:book_id => book_id})
  @books = Book.all()
  erb(:author_info)
end

patch("/books/:id") do
  book_id = params.fetch("id").to_i()
  @book = Book.find(book_id)
  author_id = params.fetch("author_id")
  @book.update({:author_id => author_id})
  @authors = Author.all()
  erb(:book_info)
end
