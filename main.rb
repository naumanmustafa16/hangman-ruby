require_relative 'lib/game'

puts 'Welcome to Hangman Game!'

game = Game.new({})

puts "If you want to play New Game. write 'New'\n
If you want to load the last saved game. Write 'Load'"
input = gets.chomp.downcase

if input == 'new'
  puts 'New Game is started'
  game.game_loop
  # File.write 'save.json', game.to_json
elsif input == 'load'
  puts 'Last saved game is loaded'
  game.from_json(File.read('save.json'))

else
  puts "Choose between 'New' or 'Load'"
end
