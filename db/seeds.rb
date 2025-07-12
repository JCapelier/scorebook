puts "Deleting DB"
Game.destroy_all
User.destroy_all
puts "DB deleted"

puts "Creating games"
Game.create!(title: "Generic score counter")
Game.create!(title: "Generic bet manager")
Game.create!(title: "Skyjo")
Game.create!(title: "Five Crowns")
Game.create!(title: "Koi Koi")
Game.create!(title: "Oh Hell (Escalier)")
Game.create!(title: "Killer")
Game.create!(title: "Azul")
Game.create!(title: "Poker")
Game.create!(title: "Scopa")
puts "Created #{Game.count} games"

puts "Creating users"
User.create(first_name: "User", last_name: "1", username: "User1", email: "test1@mail.com", password: "password")
User.create(first_name: "User", last_name: "2", username: "User2", email: "test2@mail.com", password: "password")
User.create(first_name: "User", last_name: "3", username: "User3", email: "test3@mail.com", password: "password")
User.create(first_name: "User", last_name: "4", username: "User4", email: "test4@mail.com", password: "password")
puts "Created #{User.count} users"
