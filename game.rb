require_relative 'board'

class Game

  def initialize
    @board = Board.new
    @turn = :black
    play
  end

  private
  attr_accessor :turn

  def get_input
  end

  def over?
    @board.grid.flatten.compact.none? { |piece| piece.color == turn }
  end

  def play
    until over?
      puts board
      play_turn(turn)
      @turn = (turn == :black ? :red : :black)
    end
    @turn = (turn == :black ? :red : :black)
    puts board
    puts "Game over! #{turn.capitalize} wins!"
  end

  def play_turn
  end
end