class Restaurant
  attr_reader(:name, :id, :food_type_id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @food_type_id = attributes.fetch(:food_type_id)
  end

  define_singleton_method(:all) do
    returned_restaurants = DB.exec("SELECT * FROM restaurants;")
    restaurants = []
    returned_restaurants.each() do |place|
      name = place.fetch("name")
      id = place.fetch("id").to_i
      food_type_id = place.fetch('food_type_id').to_i
      restaurants.push(Restaurant.new({:name => name, :id => id, :food_type_id => food_type_id}))
    end
    restaurants
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO restaurants (name, food_type_id) VALUES ('#{@name}', #{@food_type_id}) RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  define_method(:==) do |other_place|
    self.name().==(other_place.name()).&(self.food_type_id().==(other_place.food_type_id()))
  end
end
