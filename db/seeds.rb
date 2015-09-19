# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



unless User.find_by( email: "example@railstutorial.org" )
  User.create( name:                   "Example User",
               email:                  "example@railstutorial.org",
               password:               "foobar",
               password_confirmation:  "foobar",
               admin:                  true,
               activated:              true,
               activated_at:           Time.zone.now)
end

  99.times do |n|
    name  = Faker::Name.name()
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!( name:                   name,
                  email:                  email,
                  password:               password,
                  password_confirmation:  password,
                  activated:              true,
                  activated_at:           Time.zone.now)
  end
  User.create( name:                   "David Burke",
               email:                  "dburke@amberfire.net",
               password:               "foobar",
               password_confirmation:  "foobar",
               admin:                  false,
               activated:              true,
               activated_at:           Time.zone.now)



  users = User.order(:created_at).take(5)
  me = User.find_by(email: "dburke@amberfire.net")
  if !me.nil?
    users.push me
  end
  50.times do

    content = Faker::Lorem.sentence(5)
    until !Obscenity.profane?(content) do
      content = Faker::Lorem.sentence(5)
    end
    users.each{ |user| user.microposts.create!(content: content) }
  end
