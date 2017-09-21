class Book
  attr_reader(:title, :id)

  def initialize(attributes)
    @title = attributes[:title]
    @id = attributes[:id]
  end

  def self.all
    returned_books = DB.exec("SELECT * FROM books;")
    books = []
    returned_books.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i()
      books.push(Book.new({:title => title, :id => id}))
    end
    books
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM books WHERE id = #{id};")
    title = result.first().fetch("title")
    Book.new({:title => title, :id => id})
  end

  def save
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==(another_book)
    self.title().==(another_book.title()).&(self.id().==(another_book.id()))
  end

  def update(attributes)
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{self.id()};")

    attributes.fetch(:author_id, []).each() do |author_id|
      DB.exec("INSERT INTO books_authors (author_id, book_id) VALUES (#{author_id}, #{self.id()});")
    end

    attributes.fetch(:patron_id, []).each() do |patron_id|
      DB.exec("INSERT INTO patrons_books (patron_id, book_id) VALUES (#{patron_id}, #{self.id()});")
    end
  end

  def authors
    books_authors = []
    results = DB.exec("SELECT author_id FROM books_authors WHERE book_id = #{self.id()};")
    results.each() do |result|
      author_id = result.fetch("author_id").to_i()
      author = DB.exec("SELECT * FROM authors WHERE id = #{author_id};")
      name = author.first().fetch("name")
      books_authors.push(Author.new({:name => name, :id => author_id}))
    end
    books_authors
  end

  def patron_history
    patrons_books = []
    results = DB.exec("SELECT patron_id FROM patrons_books WHERE book_id = #{self.id()};")
    results.each() do |result|
      patron_id = result.fetch("patron_id").to_i()
      patron = DB.exec("SELECT * FROM patrons WHERE id = #{patron_id};")
      name = patron.first().fetch("name")
      patrons_books.push(Patron.new({:name => name, :id => patron_id}))
    end
    patrons_books
  end

  def delete
    DB.exec("DELETE FROM books_authors WHERE book_id = #{self.id()};")
    DB.exec("DELETE FROM patrons_books WHERE book_id = #{self.id()};")
    DB.exec("DELETE FROM books WHERE id = #{self.id()};")
  end
end
