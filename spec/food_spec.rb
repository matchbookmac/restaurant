require('spec_helper')

describe(Food) do

  describe('#type') do
    it('return the type of food') do
      test_food = Food.new({:type => 'American', :id => nil})
      expect(test_food.type()).to(eq("American"))
    end
  end

  describe('#id') do
    it('returns the id of the food type') do
      test_food = Food.new({:type => 'American', :id => nil})
      test_food.save()
      expect(test_food.id()).to(be_an_instance_of(Fixnum))
    end
  end

  describe('.all') do
    it('returns an empty array of food types to start') do
      expect(Food.all()).to(eq([]))
    end
  end

  describe('#save') do
    it('saves a new food type to the database') do
      test_food = Food.new({:type => 'American', :id => nil})
      test_food.save()
      expect(Food.all()).to(eq([test_food]))
    end
  end

  describe('#==') do
    it('returns true if the type and id are equivalent') do
      test_food_1 = Food.new({:type => 'American', :id => nil})
      test_food_2 = Food.new({:type => 'American', :id => nil})
      expect(test_food_1).to(eq(test_food_2))
    end
  end

  describe('.find') do
    it('return the object by its id') do
      test_1 = Food.new({:type => "American", :id => nil})
      test_1.save()
      test_2 = Food.new({:type => "Chinese", :id => nil})
      test_2.save()
      expect(Food.find(test_2.id())).to(eq(test_2))
    end
  end

  describe('#update') do
    it('updates the database for a given food type') do
      test_1 = Food.new({:type => "American", :id => nil})
      test_1.save()
      test_1.update({:type => "Korean"})
      expect(test_1.type()).to(eq("Korean"))
    end

    it('lets you add multiple restaurants for one food type') do
      test_food = Food.new({:type => "American", :id => nil})
      test_food.save()
      test_restaurant = Restaurant.new({:name => "BBQ Hut", :id => nil})
      test_restaurant.save()
      test_restaurant_2 = Restaurant.new({:name => "Freddys Ribs", :id => nil})
      test_restaurant_2.save()
      test_food.update({:restaurant_ids => [test_restaurant.id(), test_restaurant_2.id()]})
      expect(test_food.restaurants()).to(eq([test_restaurant, test_restaurant_2]))
    end
  end

  describe('#delete') do
    it('remove food type from database') do
      test_1 = Food.new({:type => "American", :id => nil})
      test_1.save()
      test_1.delete()
      expect(Food.all()).to(eq([]))
    end
  end

end
