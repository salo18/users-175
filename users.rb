=begin
Requirements:
- user loads home page, should be redirected to page that lists all user names from yaml file
- each user name should link to a page for that user
  - on each user's page, display email address and their interests separated by commas
  - at the bottom, list links to all other user pages. don't include current user
- add layout to application
  - bottom of each page, display "There are X users with a total of X interests."
  - use helper method count_interests to determine total interests across all users
- add a new user to yaml and verify that site updates accordingly
=end

require 'sinatra'
require "sinatra/reloader" if development?
require "tilt/erubis"
require "yaml"

def interests_q(file)
  counter = 0
  file.each do |k, v|
    counter += v[:interests].size
  end
  counter
end

before do
  @load = YAML.load_file("users.yaml")
  @user_num = @load.keys.size
  @interest_num = interests_q(@load)
  @footer = "There are #{@user_num} users and #{@interest_num} interests"
end

get "/" do
  redirect "/users"
end

helpers do

end

get "/users" do
  @names = @load.keys.map(&:to_s).map(&:capitalize)
  erb :users
end

get "/users/*" do
  @user = params["splat"][0].downcase
  @name = @user.capitalize
  @email = @load[@user.to_sym][:email]
  @interests = @load[@user.to_sym][:interests].join(", ")
  @others = @load.keys.map(&:to_s) - [@user]
  erb :profiles
end

# test