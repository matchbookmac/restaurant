class Restaurant
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_restaurants = DB.exec("SELECT * FROM restaurants;")
    restaurants = []
    returned_restaurants.each() do |place|
      name = place.fetch("name")
      id = place.fetch("id").to_i
      restaurants.push(Restaurant.new({:name => name, :id => id}))
    end
    restaurants
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO restaurants (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM restaurants WHERE id = #{@id};")
    @name = result.first().fetch('name')
    Restaurant.new({:name => @name, :id => @id})
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    @id = self.id()
    DB.exec("UPDATE restaurants SET name = '#{@name}' WHERE id = #{@id};")

    food_type_ids = attributes.fetch(:food_type_ids, [])
    food_type_ids.each() do |food_id|
      DB.exec("INSERT INTO restaurants_food_types (restaurant_id, food_type_id) VALUES (#{@id}, #{food_id});")
    end
  end

  define_method(:food_types) do
    food_types = []
    results = DB.exec("SELECT food_type_id FROM restaurants_food_types WHERE restaurant_id = #{id()};")
    results.each() do |result|
      food_type_id = result.fetch("food_type_id").to_i()
      food_type =  DB.exec("SELECT * FROM food_types WHERE id = #{food_type_id};")
      type = food_type.first().fetch("food_type")
      food_types.push(Food.new({:type => type, :id => food_type_id}))
    end
    food_types
  end

  define_method(:delete) do
    DB.exec("DELETE FROM restaurants WHERE id = #{self.id()};")
    DB.exec("DELETE FROM restaurants_food_types WHERE restaurant_id = #{self.id()};")
  end

  define_method(:==) do |other_place|
    self.name().==(other_place.name())
  end
end


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

  define_singleton_method(:find) do |id|
    @id = id
    result = DB.exec("SELECT * FROM food_types WHERE id = #{@id};")
    type = result.first().fetch("food_type")
    Food.new({:type => type, :id => id})
  end

  define_method(:update) do |attributes|
    @type = attributes.fetch(:type, @type)
    DB.exec("UPDATE food_types SET food_type = '#{@type}' WHERE id = #{self.id()};")
    @restaurant_ids = attributes.fetch(:restaurant_ids, [])
    @restaurant_ids.each() do |place_id|
      DB.exec("INSERT INTO restaurants_food_types (restaurant_id, food_type_id) VALUES (#{place_id}, #{self.id()});")
    end
  end

  define_method(:delete) do
    DB.exec("DELETE FROM food_types WHERE id = #{id()};")
    DB.exec("DELETE FROM restaurants_food_types WHERE food_type_id = #{id()};")
  end

  define_method(:==) do |other_type|
    self.type().==(other_type.type()).&(other_type.id().==(self.id()))
  end

  define_method(:restaurants) do
    restaurants = []
    results = DB.exec("SELECT restaurant_id FROM restaurants_food_types WHERE food_type_id = #{self.id()};")
    results.each() do |result|
      restaurant_id = result.fetch("restaurant_id").to_i()
      restaurant = DB.exec("SELECT * FROM restaurants WHERE id = #{restaurant_id};")
      name = restaurant.first().fetch("name")
      restaurants.push(Restaurant.new({:name => name, :id => restaurant_id}))
    end
    restaurants
  end


end





test_food = Food.new({:type => 'American', :id => nil})
puts(test_food.type())
