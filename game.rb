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
    begin
      puts "#{turn.capitalize}, please enter a move. Example format: '26 35 46'"
      input = gets.chomp
      unless input =~ /^[0-9]{2}[\s[0-9]{2}]+/
        raise InvalidMoveError.new "Formatting issue."
      end
    rescue InvalidMoveError => e
      puts e.message
      retry
    end

    input.split.map do |pos|
      [Integer(pos[0]), Integer(pos[1])]
    end
  end

  def over?
    @board.grid.flatten.compact.none? { |piece| piece.color == turn }
  end

  def play
    until over?
      puts @board
      play_turn
      @turn = (turn == :black ? :white : :black)
    end
    @turn = (turn == :black ? :white : :black)
    puts @board
    puts "Game over! #{turn.capitalize} wins!"
  end

  def play_turn
    begin
      move_seq = get_input
      if @board[move_seq.first].color != turn
        raise InvalidMoveError.new "Cannot move opponent's piece."
      elsif @board.empty?(move_seq.first)
        raise InvalidMoveError.new "No piece here."
      end
      @board.perform_moves(move_seq)
    rescue InvalidMoveError => e
      puts "You've made some sort of invalid move. Please try again."
      puts "Error: #{e.message}"
      retry
    end
  end
end

Game.new