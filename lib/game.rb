# frozen_string_literal: true

require 'json'
# In this class game will be played

class Game
  # attr_reader :secret_word, :right_letters, :mistakes, :wrong_letters

  def initialize(args)
    @secret_word = args.fetch(:secret_word, '')
    @right_letters = args.fetch(:right_letters, [])
    @mistakes = args.fetch(:mistakes, 0)
    @wrong_letters = args.fetch(:wrong_letters, [])
  end

  def read_word_file
    File.read('words.txt').split
  end

  def choose_secret_word
    allowable_words = read_word_file.select do |word|
      word.length >= 5 && word.length <= 12
    end
    allowable_words[rand(allowable_words.length)]
  end

  def to_json(*_args)
    JSON.dump({
                secret_word: @secret_word,
                mistakes: @mistakes,
                wrong_letters: @wrong_letters,
                right_letters: @right_letters
              })
  end

  def from_json(string)
    data = JSON.load(string)
    # p string
    # puts "I have read the #{string}"
    Game.new({
               secret_word: data['secret_word'],
               mistakes: data['mistakes'],
               wrong_letters: data['wrong_letters'],
               right_letters: data['right_letters']
             }).game_loop
  end

  def game_loop
    @secret_word = if @secret_word.length < 5
                     puts 'Computer has choosen something'
                     choose_secret_word
                   else
                     @secret_word
                   end

    random_word = @secret_word.split('')
    hidden_word = if (('a'..'z').to_a & @right_letters).empty?
                    random_word.map { |e| e = '_' }
                  else
                    hidden_word = @right_letters

                  end

    p hidden_word
    # p random_word
    while @mistakes < 8
      @right_letters = hidden_word
      puts 'Do you want to save the game? y/n'
      save_input = gets.chomp.downcase
      if save_input == 'y'
        File.write('save.json', to_json)
        puts 'Game is saved.'
        break
      else

        puts 'guess the word'
        guess = gets.chomp.downcase
        if random_word.include?(guess)
          puts 'You guessed it right'
          puts "Your wrong guesses are #{@wrong_letters}"
          puts "You can make #{8 - @mistakes} mistakes"
          index = random_word.each_index.select { |i| random_word[i] == guess }
          # p index
          index.each { |i| hidden_word[i] = guess }
          # p random_word
          p hidden_word

        else
          @mistakes += 1
          puts "Your wrong guesses are #{@wrong_letters.push(guess)}"
          puts "You can make #{8 - @mistakes} mistakes"
          p hidden_word
        end

        if hidden_word == random_word
          puts ' You win'
          break
        end
        puts "You Lose. The word was '#{random_word.join}'" if @mistakes == 8
      end
    end
  end
end
