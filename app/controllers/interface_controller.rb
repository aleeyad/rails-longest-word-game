require 'open-uri'
require 'json'

class InterfaceController < ApplicationController

  def game
    generate_grid
  end

  def score
    @saved_grid = params[:saved_grid]
    @query = params[:query]
    @start_time = params[:start_time].to_i
    @time_end = (Time.now).to_i
    @time = (@time_end - @start_time)
    score_and_message
  end

  protected

  def generate_grid
    array = ("A".."Z").to_a
    return @grid = Array.new(9) { array.sample }
  end

  def included?
    # @query_array = []
    # @query_array = @query.split("").to_a
    @query.chars.all? { |letter| @query.upcase.count(letter) <= @saved_grid.count(letter) }
  end

  def valid_word?
    url = open("https://wagon-dictionary.herokuapp.com/#{@query}")
    json = JSON.parse(url.read)
    return json['found']
  end

  def compute_score
    @time > 60.0 ? 0 : @query.size * (1.0 - @time / 60.0)
  end

  def score_and_message
    @result = Hash.new
    if included?
      if valid_word?
        return @result = {score: compute_score, message: "Well done!", time: @time}
      else
        return @result = {score: 0, message: "Not an english word", time: @time}
      end
    else
      return @result = {score: 0, message: "Not in the grid!", time: @time}
    end
  end

end
