# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'
require 'byebug'

puts 'Cleaning database...'

Cocktail.destroy_all
Dose.destroy_all
Ingredient.destroy_all

puts 'Creating ingredients...'

# url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
# # ingredients = JSON.parse(open(url).read) # substituted for security issue
# ingredients = JSON.parse(URI.parse(url).open.read)
# ingredients['drinks'].each do |ingredient|
#   Ingredient.create!({ name: ingredient['strIngredient1'] })
# end

url = 'https://gist.githubusercontent.com/JSpiner/412a532e9aea9a554ea4d13142aaa5dd/raw/bbede48f96fcfd71966df0e9d0c9aa78a10965fa/cocktail.json'
cocktail_formulas = JSON.parse(URI.parse(url).open.read)
cocktail_formulas.each do |cocktail_formula|
  ingredients_h = {}
  doses_h = {}
  # cocktail_name = cocktail_formula['strDrink'].strip
  # Cocktail.create!(name: cocktail_name)
  cocktail_formula.each do |k, v|
    if k[0..12] == 'strIngredient' && !v.nil? && !v.strip.empty?
      ingredients_h[k[13..]] = v.strip
    elsif k[0..9] == 'strMeasure' && !v.nil? && !v.strip.empty?
      doses_h[k[10..]] = v.strip
    end
  end
  ingredients_h.each do |k, v|
    # feed tb ingredients if ingredients_h[i] doesn't exist
    Ingredient.create!(name: v) if Ingredient.where(name: v).count.zero?
    # ingredient = Ingredient.where(name: v)
    # cocktail = Cocktail.last
    # Doses.create!(ingredient_id: ingredient.id, cocktail_id: cocktail.id, description: doses_h[k])
  end
end
