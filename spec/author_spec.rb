require("spec_helper")

describe(Author) do

  describe("#initialize") do
    it("is initialized with a name") do
      author = Author.new({:name => "F. Scott Fitzgerald", :id => nil})
      expect(author).to(be_an_instance_of(Author))
    end

    it("can be initialized with its database ID") do
      author = Author.new({:name => "F. Scott Fitzgerald", :id => 1})
      expect(author).to(be_an_instance_of(Author))
    end
  end

  describe(".all") do
    it("starts off with no authors") do
      expect(Author.all()).to(eq([]))
    end
  end

  describe(".find") do
    it("returns a author by its ID number") do
      test_author = Author.new({:name => "F. Scott Fitzgerald", :id => nil})
      test_author.save()
      test_author2 = Author.new({:name => "Dr. Suess", :id => nil})
      test_author2.save()
      expect(Author.find(test_author2.id())).to(eq(test_author2))
    end
  end

  describe("#==") do
    it("is the same author if it has the same name and id") do
      author = Author.new({:name => "F. Scott Fitzgerald", :id => nil})
      author2 = Author.new({:name => "F. Scott Fitzgerald", :id => nil})
      expect(author).to(eq(author2))
    end
  end

  describe("#update") do
    it("lets you update authors in the database") do
      author = Author.new({:name => "Dr. Suess", :id => nil})
      author.save()
      author.update({:name => "F. Scott Fitzgerald"})
      expect(author.name()).to(eq("F. Scott Fitzgerald"))
    end

    it("lets you add a book to an author") do
      book = Book.new({:title => "Tender is the Night", :id => nil})
      book.save()
      author = Author.new({:name => "F. Scott Fitzgerald", :id => nil})
      author.save()
      author.update({:book_id => [book.id()]})
      expect(author.books()).to(eq([book]))
    end
  end

  describe("#books") do
    it("returns all of the books a particular author has written") do
      book = Book.new(:title => "The Great Gatsby", :id => nil)
      book.save()
      book2 = Book.new(:title => "Tender is the Night", :id => nil)
      book2.save()
      author = Author.new(:name => "F. Scott Fitzgerald", :id => nil)
      author.save()
      author.update(:book_id => [book.id()])
      author.update(:book_id => [book2.id()])
      expect(author.books()).to(eq([book, book2]))
    end
  end

  describe("#delete") do
    it("lets you delete an author from the database") do
      author = Author.new({:name => "Dr. Suess", :id => nil})
      author.save()
      author2 = Author.new({:name => "F. Scott Fitzgerald", :id => nil})
      author2.save()
      author.delete()
      expect(Author.all()).to(eq([author2]))
    end
  end
end
