# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

5.times do
  user = User.new(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Lorem.characters(10)    
  )
  user.skip_confirmation!
  user.save!
end
users = User.all

# Create an admin user, not inlcuded in above users array
admin = User.new(
  name:     'Admin User',
  email:    'admin@example.com',
  password: 'helloworld',
  role:     'admin'
  )
admin.skip_confirmation!
admin.save!

10.times do 
  wiki = Wiki.create!(
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph,
    private: false,
    user: users.sample   
  )  
end
puts "Seeding finished"
puts "#{User.count} Users created"
puts "#{Wiki.count} Wikis created"  
    