require('spec_helper')

describe(Restaurant) do

  describe('#name') do
    it('return the name of a restaurant object') do
      test_restaurant = Restaurant.new({:name => "BBQ Hut", :id => nil})
      expect(test_restaurant.name()).to(eq("BBQ Hut"))
    end
  end

  describe('#id') do
    it('return the id of a restaurant when called') do
      test_1 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_1.save()
      expect(test_1.id()).to(be_an_instance_of(Fixnum))
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

  describe('.find') do
    it('will find a restaurant from its id') do
      test_1 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_1.save()
      test_2 = Restaurant.new({:name => "Freddys ribs", :id => nil})
      test_2.save()
      expect(Restaurant.find(test_2.id())).to(eq(test_2))
    end
  end

  describe('#update') do
    it('will update a restaurant\'s record in the database') do
      test_1 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_1.save()
      test_1.update({:name => 'Freddys Ribs'})
      expect(test_1.name()).to(eq('Freddys Ribs'))
    end

    it('lets you add multiple food types for to a restaurant') do
      test_restaurant = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_restaurant.save()
      test_food = Food.new({:type => "American", :id => nil})
      test_food.save()
      test_food_2 = Food.new({:type => "Mexican", :id => nil})
      test_food_2.save()
      test_restaurant.update({:food_type_ids => [test_food.id(), test_food_2.id()]})
      expect(test_restaurant.food_types()).to(eq([test_food, test_food_2]))
    end
  end

  describe('#delete') do
    it('will delete a restaurant from the database') do
      test_1 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_1.save()
      test_2 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_2.save()
      test_1.delete()
      expect(Restaurant.all()).to(eq([test_2]))
    end
  end

  describe('#==') do
    it('returns true if the restaurants\' names are the same') do
      test_1 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_2 = Restaurant.new({:name => "BBQ Hut", :id => nil})
      expect(test_1).to(eq(test_2))
    end
  end

end
