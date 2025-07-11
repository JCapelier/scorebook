puts "Deleting DB"
Game.destroy_all
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
