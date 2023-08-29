require 'open-uri'

class GamesController < ApplicationController
  def new
    i = 0
    @generated_letters = []
    letters = ('A'..'Z').to_a
    until i == 10
      i += 1
      @generated_letters << letters[rand(letters.count-1)]
    end
  end

  def word_valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    letter_hash_string = URI.open(url).read
    letter_hash = JSON.parse(letter_hash_string)
    letter_hash['found']
  end

  def letter_present?(letter_array, word)
    raise
    # break word up into an array of letters
    word_array = word.upcase.chars
    # for each letter
    word_array.each do |letter|
      # check if it is present in letter_array
      index = letter_array.index(letter)

      return false if index.nil?

      letter_array.delete_at(index)
    end

    true
  end

  def score
    generated_letters = params[:generated_letters].chars.compact_blank
    @word = params[:answer]
    # raise
    if word_valid?(@word) && letter_present?(generated_letters, @word)
      @response = "Congratulations, #{@word.upcase} is a valid English word. Your score is #{@word.length}!"
    elsif word_valid?(@word)
      @response = "Sorry but #{@word.upcase} can't be built out of #{generated_letters.join(', ')}"
    else
      @response = "Sorry but #{@word.upcase} doesn't seem to be a valid english word..."
    end
  end
end
