require 'sinatra'
require 'data_mapper'
require_relative 'database'
#
# @title My own To-Do-List/Reminder App
# @author josh Lin joshlin@uw.edu
# @last_update 12-05-2011
#

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
  
  now = Time.now
  
  item = Item.create :detail => params[:detail], 
    :created_at => now, 
    :updated_at => now
    
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
  
  if item = Item.get(params[:id])

    item.update :detail => params[:detail], 
      :complete => (params[:complete] ? 1 : 0),
      :updated_at => Time.now
    
  end
  
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
  
  if item = Item.get(params[:id])
    item.destroy
  end
  
  redirect '/'  
end  

# Complete
get '/:id/complete' do
  
  if item = Item.get(params[:id])
    
    item.update :complete => (item.complete ? 0 : 1), 
      :updated_at => Time.now
      
  end
  
  redirect '/'
end
