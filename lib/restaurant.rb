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
