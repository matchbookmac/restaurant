require('spec_helper')

describe(Restaurant) do

  describe('#name') do
    it('return the name of a restaurant object') do
      test_restaurant = Restaurant.new({:name => "BBQ Hut", :id => nil})
      expect(test_restaurant.name()).to(eq("BBQ Hut"))
    end
  end

  describe('.all') do
    it('will return an empty array to start') do
      expect(Restaurant.all()).to(eq([]))
    end
  end

  describe('#save') do
    it('will save a new restaurant to the database') do
      test_restaurant = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_restaurant.save()
      expect(Restaurant.all()).to(eq([test_restaurant]))
    end
  end

  describe('#==') do
    it('returns true if the restaurants\' names are the same') do
      test_1 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_2 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      expect(test_1).to(eq(test_2))
    end
  end

  describe('#id') do
    it('return the id of a restaurant when called') do
      test_1 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_1.save()
      expect(test_1.id()).to(be_an_instance_of(Fixnum))
    end
  end
end
