require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters]
    @answer = params[:answer].upcase
    if english_word?(@answer.to_s) && included?(@answer, @letters)
      @great = @answer
    elsif included?(@answer, @letters) && english_word?(@answer.to_s) == false
      @is_not_a_word = @answer
    elsif included?(@answer, @letters) == false
      @is_not_included = @answer
    end
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    @input = json['found']
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end
end
