require 'spec_helper'

describe(Patron) do


  describe(".all") do
    it("starts off with no patrons") do
      expect(Patron.all()).to(eq([]))
    end
  end

  describe(".find") do
    it("returns a patron by their ID number") do
      patron = Patron.new({:name => "Keegan", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron.save()
      patron2 = Patron.new({:name => "Riki", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron2.save()
      expect(Patron.find(patron2.id())).to(eq(patron2))
    end
  end

  describe("#==") do
    it("is the same patron if it has the same name and id") do
      patron = Patron.new({:name => "Keegan", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron2 = Patron.new({:name => "Keegan", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      expect(patron).to(eq(patron2))
    end
  end

  describe("#update") do
    it("lets you update patrons in the database") do
      patron = Patron.new({:name => "Keegan", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron.save()
      patron.update({:name => "Riki"})
      expect(patron.name()).to(eq("Riki"))
    end

    it("lets you add a book to a patron") do
      book = Book.new({:title => "Tender is the Night", :id => nil})
      book.save()
      patron = Patron.new({:name => "Keegan", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron.save()
      patron.update({:book_id => [book.id()]})
      expect(patron.checkout_history()).to(eq([book]))
    end
  end

  describe("#checkout_history") do
    it("returns all of the books a particular patron has checked out") do
      book = Book.new(:title => "The Great Gatsby", :id => nil)
      book.save()
      book2 = Book.new(:title => "Tender is the Night", :id => nil)
      book2.save()
      patron = Patron.new({:name => "Keegan", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron.save()
      patron.update(:book_id => [book.id()])
      patron.update(:book_id => [book2.id()])
      expect(patron.checkout_history()).to(eq([book, book2]))
    end
  end

  describe("#delete") do
    it("lets you delete a patron from the database") do
      patron = Patron.new({:name => "Keegan", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron.save()
      patron2 = Patron.new({:name => "Riki", :id => nil, :phone => "555-555-5555", :date => "2017-09-20"})
      patron2.save()
      patron.delete()
      expect(Patron.all()).to(eq([patron2]))
    end
  end
end
