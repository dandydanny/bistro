require 'csv'

class Recipe
  attr_reader :id
  attr_accessor :name, :description, :ingredients, :directions
  def initialize(recipeparams)
    @id = recipeparams[:id]
    @name = recipeparams[:name]
    @description = recipeparams[:description]
    @ingredients = recipeparams[:ingredients]
    @directions = recipeparams[:directions]
  end

  # Mike's tip: separation of concerns,
  # law of demeter (only call your closest friends)
  def listing
    "#{id}. #{name}"
  end

  # separation
  def long_description
<<-STRING
________________________________________________________________________________
#{name} (ID: #{id})

Description:
#{description}

Ingredients:
#{ingredients}

Directions:
#{directions}

________________________________________________________________________________
STRING
  end

  def to_s
    long_description
  end
end

class Bistro

  def initialize
    @recipes = [] # An array of recipe objects
  end

  # Loads CSV file and return recipes as an array of hashes
  def load_recipes(filename)
    CSV.foreach(filename, :headers => true) do |row|
      recipeparams = {:id => row[0],
                      :name => row[1],
                      :description => row[2],
                      :ingredients => row[3],
                      :directions => row[4]
                     }
      @recipes << Recipe.new(recipeparams)
    end

    @recipes
  end

  # Returns found recipe as obj. If not found, return nil
  def find_recipe_by_id(recipe_id)
    # recipe = nil
    @recipes.each do |record|
      if record.id == recipe_id.to_s
        # recipe = record
        return record
      end
    end

    nil
    # recipe
  end

  def list_recipes(recipes=@recipes)
    string = "ID  Name\n"

    recipes.each do |record|
      # print " " if record.id.length == 1
      string << record.listing + "\n"
    end

    string
  end

  def list_sorted_recipes(recipes=@recipes)
    sorted_recipes = recipes.sort_by!{|item| item.name}
    list_recipes(sorted_recipes)
  end

end


def mainloop
  input = "0"
  while input != "q"
    puts "Welcome to Quickcipes Redux"
    @bistro.list_recipes
    puts "Enter a number to display a recipe. Enter 'q' to quit."

    # gets.chomp somehow looks for a file called "start"
    # using $stdin.gets.chomp instead
    input = $stdin.gets.chomp

    break if input == "q"

    @bistro.display_recipe_by_id(input)
    puts "Press any key to return to main menu. 'q' to quit."

    input = $stdin.gets.chomp
    clear_screen
  end
  puts "Good bye!"
end

def clear_screen
  puts "\e[H\e[2J"
end

def display_useage
<<-STRING
ruby bistro.rb [command] [parameter]

Commands & Sample Parameters"
load recipes.csv"
 - Loads the recipes.csv into memory."
list"
 - List all recipes"
sortedlist"
 - List all recipes in alphabetical order"
display 1"
 - Displays the recipe with ID number 1."
start"
 - Start the main user interface."
bistro.rb /?"
 - Displays the sample useage examples you're reading now."
STRING
end

if ARGV.any?
  @bistro = Bistro.new
  @bistro.load_recipes("recipes.csv")
  command = ARGV[0]
  arguments = ARGV.slice(1..-1)

  case command
  when "load"
    p @bistro.load_recipes(*arguments)
  when "list"
    puts @bistro.list_recipes
  when "sortedlist"
    @bistro.list_sorted_recipes
  when "display"
    puts @bistro.find_recipe_by_id(*arguments)
  when "start"
    clear_screen
    mainloop
  else
    puts display_useage
  end

end

puts display_useage
