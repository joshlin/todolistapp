require 'sinatra'
require 'data_mapper'
#require_relative 'database'
#
# @title My own To-Do-List/Reminder App
# @author josh Lin joshlin@uw.edu
# @last_update 12-05-2011
#

# Set up the database
DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
  
class Item
  include DataMapper::Resource  
  property :id, Serial  
  property :detail, Text, :required => true  
  property :complete, Boolean, :required => true, :default => false  
  property :created_at, DateTime  
  property :updated_at, DateTime  
end  
  
DataMapper.finalize.auto_upgrade!

set :views, settings.root + '/../views'
set :public_folder, settings.root + '/../public'

# Index
get '/' do
  @items = Item.all :order => :id.desc
  @title = "Josh's To Do List "
  erb :home
end

# Create
post '/' do
  item = Item.new
  item.detail = params[:detail]
  item.created_at = Time.now
  item.updated_at = Time.now
  item.save
  redirect '/'
end

# Edit
get '/:id' do  
  @item = Item.get params[:id]  
  @title = "Edit item - #{params[:id]}"
  erb :edit
end

# Update
put '/:id' do  
  item = Item.get params[:id]  
  item.detail = params[:detail]  
  item.complete = params[:complete] ? 1 : 0  
  item.updated_at = Time.now  
  item.save  
  redirect '/'  
end  

# Delete Confirm
get '/:id/delete' do  
  @item = Item.get params[:id]  
  @title = "Confirm deletion of Task ##{params[:id]}"  
  erb :delete  
end  

# Delete
delete '/:id' do  
  item = Item.get params[:id]  
  item.destroy  
  redirect '/'  
end  

# Complete
get '/:id/complete' do  
  item = Item.get params[:id]  
  item.complete = item.complete ? 0 : 1 
  item.updated_at = Time.now  
  item.save  
  redirect '/'  
end
