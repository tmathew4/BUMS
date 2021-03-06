# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

events = [{:name => 'Who Wants Some Grub?', :date => '25-Nov-1992', :ethnicity => {"Asian" => "1"}, :dietary_restrictions => {"Gluten_free" => "1"}, :category => {"Dinner" => "1"}, :user_id => 1},
    	  {:name => 'Meat festival', :date => '22-Nov-2017', :description => 'lots of meat', :ingredients => 'meat', :ethnicity => {"French" => "1"}, :dietary_restrictions => {"Gluten_free" => "1"}, :category => {"Lunch" => "1"}, :user_id => 1}]
    	  
users = [{:name => "Jordan Raitses", :uid => "118062694721796605976", :provider => "google_oauth2"},
         {:name => "Tiffany Pappalardo"}]

events.each do |event|
  Event.create!(event)
end

users.each do |user|
  User.create!(user)
end