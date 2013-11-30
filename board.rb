require 'colorize'
require_relative 'piece.rb'

class Board
  attr_accessor :grid

  def initialize(set_up = true)
    @grid = make_grid
    set_pieces if set_up
  end

  def [](position)
    @grid[position[0]][position[1]]
  end

  def []=(position, piece)
    @grid[position[0]][position[1]] = piece
  end

  def empty?(position)
    self[position].nil?
  end

  def perform_moves!(move_sequence)

  end

  def perform_jump(start,finish)
    jump = [(start[0] + finish[0])/2, (start[1] + finish[1])/2]
    return false if self.empty?(jump)
    start_includes_finish = self[start].moves.include?(finish)
    start_color_diff_from_jump_color = self[jump].color != self[start].color
    !self.empty?(start) && self.empty?(finish) && start_includes_finish &&
                    start_color_diff_from_jump_color
  end

  def perform_slide(start,finish)
    start_includes_finish = self[start].moves.include?(finish)
    !self.empty?(start) && self.empty?(finish) && start_includes_finish
  end

  def to_s
    output = ""
    10.times do |row|
      @grid[row].each_with_index do |piece, col|
        bg = (row.odd? ^ col.odd? ? :light_white : :white)
        if piece.nil?
          output += "  ".colorize(:color => :black, :background => bg)
        else
          output += "#{piece} ".colorize(:color => :black, :background => bg)
        end
      end
      output << "\n"
    end
    output
  end

  private
  def make_grid
    Array.new(10){Array.new(10){nil}}
  end

  def set_pieces
    10.times do |row|
      next if row == 4 || row == 5
      10.times do |col|
        next unless row.odd? ^ col.odd?
        if row < 4
          @grid[row][col] = Piece.new([row,col],:black,self)
        else
          @grid[row][col] = Piece.new([row,col],:red,self)
        end
      end
    end
  end
end

board = Board.new
puts board
