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
end
