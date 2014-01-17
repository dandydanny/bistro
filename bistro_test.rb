require_relative('bistro')

# Your driver code here
bistro = Bistro.new
clear_screen

puts "------ Running bistro_test"
puts "------ Goal: try to utilize most things learned so far"
bistro.load_recipes("recipes.csv")
gets.chomp

puts "----------- listing all recipes"
bistro.list_recipes
gets.chomp
# bistro.list_recipes()

puts "-----------"
bistro.display_recipe_by_id(4)
gets.chomp
