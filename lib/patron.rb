class Patron
  attr_reader(:name, :id, :phone, :date)

  def initialize(attributes)
    @name = attributes[:name]
    @id = attributes[:id]
    @phone = attributes[:phone]
    @date = attributes[:date]
  end

  def self.all
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    patrons = []
    returned_patrons.each() do |patron|
      name = patron.fetch("name")
      id = patron.fetch("id").to_i()
      phone = patron.fetch("phone")
      date = patron.fetch("date")
      patrons.push(Patron.new({:name => name, :id => id, :phone => phone, :date => date}))
    end
    patrons
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM patrons WHERE id = #{id};")
    name = result.first().fetch("name")
    id = result.first().fetch("id").to_i()
    phone = result.first().fetch("phone")
    date = result.first().fetch("date")
    Patron.new({:name => name, :id => id, :phone => phone, :date => date})
  end

  def save
    result = DB.exec("INSERT INTO patrons (name, phone, date) VALUES ('#{@name}', '#{@phone}', '#{@date}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==(another_patron)
    self.name().==(another_patron.name()).&(self.id().==(another_patron.id()))
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE patrons SET name = '#{@name}', phone = '#{@phone}', date = '#{@date}' WHERE id = #{self.id()};")

    attributes.fetch(:book_id, []).each() do |book_id|
      DB.exec("INSERT INTO patrons_books (patron_id, book_id) VALUES (#{self.id()}, #{book_id});")
    end
  end

  def checkout_history
    patrons_books = []
    results = DB.exec("SELECT book_id FROM patrons_books WHERE patron_id = #{self.id()};")
    results.each() do |result|
      book_id = result.fetch("book_id").to_i()
      book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      title = book.first().fetch("title")
      patrons_books.push(Book.new({:title => title, :id => book_id}))
    end
    patrons_books
  end

  def delete
    DB.exec("DELETE FROM patrons_books WHERE book_id = #{self.id()};")
    DB.exec("DELETE FROM patrons WHERE id = #{self.id()};")
  end
end
