class Food
  attr_reader(:type, :id)

  define_method(:initialize) do |attributes|
    @type = attributes.fetch(:type)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_foods = DB.exec("SELECT * FROM food_types;")
    food_types = []
    returned_foods.each() do |food|
      food_type = food.fetch("food_type")
      id = food.fetch("id").to_i()
      food_types.push(Food.new({:type => food_type, :id => id}))
    end
    food_types
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO food_types (food_type) VALUES ('#{@type}') RETURNING id")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |other_type|
    self.type().==(other_type.type()).&(other_type.id().==(self.id()))
  end
end
