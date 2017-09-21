require 'sinatra'
require 'sinatra/reloader'
require './lib/book'
require './lib/patron'
require './lib/author'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec('DELETE FROM authors *;')
    DB.exec('DELETE FROM books *;')
    DB.exec('DELETE FROM patrons *;')
    DB.exec('DELETE FROM patrons_books *;')
    DB.exec('DELETE FROM books_authors *;')
  end
end
