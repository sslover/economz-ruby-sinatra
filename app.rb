require 'sinatra'
require 'dm-core'

DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'})

class Recipe
  include DataMapper::Resource

  property :id, Serial
  property :active, Integer
  property :fooditem, String
  property :name, String
  property :url, String
end

DataMapper.finalize

get '/' do
  # processing sketch goes here, users can save and share on twitter
  @nav = "home"
  erb :home
end

get '/gallery' do
	# shows featured foods with recipes
	# allows users to submit recipes for eco-friendly foods
	@nav = "gallery"
	@internal = "true"
    @recipes = Recipe.all
	erb :gallery
end

post '/gallery' do
	#post suggested recipe 
	@nav = "gallery"
	@recipes = Recipe.all
	@recipe = Recipe.new
	@recipe.fooditem = params[:fooditem]
	@recipe.name = params[:name]
	@recipe.active = 0;
	@recipe.url = params[:url]
	@recipe.save
	erb :gallery_success
end

get '/physical-installation' do
	# shows info about the physicall installation
	@nav = "physical installation"
	@internal = "true"
	erb :physical
end

get '/about' do
	# about page
	@nav = "about"
	@internal = "true"
	erb :about
end

get '/sam-admin-panel' do
	# admin panel to see records
	@nav = "admin"
	@internal = "true"
    @recipes = Recipe.all
	erb :admin 
end

get "/:id/edit" do
  @nav = "admin edit"
  @updateRecipe = Recipe.get(params[:id])
  @id = params[:id]
  updateRecipe = Recipe.get(params[:id])
  updateRecipe.fooditem = params[:fooditem]
  updateRecipe.active = params[:active]
  erb :edit 
end

post "/:id/edit" do
  updateRecipe = Recipe.get(params[:id])
  updateRecipe.fooditem = params[:fooditem]
  updateRecipe.name = params[:name]
  updateRecipe.active = params[:active]
  updateRecipe.url = params[:url]
  
  if(updateRecipe.save)
    redirect to("http://itp.nyu.edu/~sjs663/sinatra/economz/sam-admin-panel")
  else
    "Did not save :("
  end
end
 
get "/:id/delete" do
  
  deleteRecipe = Recipe.get(params[:id])
  deleteRecipe.destroy
  redirect to("http://itp.nyu.edu/~sjs663/sinatra/economz/sam-admin-panel")
end

get "/:id/active" do
  
  updateRecipe = Recipe.get(params[:id])
  updateRecipe.active = params[:active]
  updateRecipe.active = 1
  if(updateRecipe.save)
    redirect to("http://itp.nyu.edu/~sjs663/sinatra/economz/sam-admin-panel")
  else
    "Did not save :("
  end
end

get "/:id/deactive" do
  
  updateRecipe = Recipe.get(params[:id])
  updateRecipe.active = params[:active]
  updateRecipe.active = 0
  if(updateRecipe.save)
    redirect to("http://itp.nyu.edu/~sjs663/sinatra/economz/sam-admin-panel")
  else
    "Did not save :("
  end
end