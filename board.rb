require_relative 'piece.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = make_grid
    set_pieces
  end

  def perform_moves!(move_sequence)
    # This is where I left off
  end

  def perform_jump(start,finish)
    start_spot = @grid[start[0]][start[1]]
    finish_spot = @grid[finish[0]][finish[1]]
    jump_spot = @grid[(start[0] + finish[0])/2][(start[1] + finish[1])/2]
    empty_start = start_spot.nil?
    empty_finish = finish_spot.nil?
    start_includes_finish = start_spot.moves.include?(finish)
    empty_jump = jump_spot.nil?
    start_color_diff_from_jump_color = jump_spot.color != start_spot.color
    !empty_start && empty_finish && start_includes_finish && !empty_jump &&
                    start_color_diff_from_jump_color
  end

  def perform_slide(start,finish)
    start_spot = @grid[start[0]][start[1]]
    finish_spot = @grid[finish[0]][finish[1]]
    empty_start = start_spot.nil?
    empty_finish = finish_spot.nil?
    start_includes_finish = start_spot.moves.include?(finish)
    !empty_start && empty_finish && start_includes_finish
  end

  def to_s
    output = ""
    @grid.each_with_index do |row,i|
      row.each do |piece|
        if piece.nil?
          output += "  "
        else
          output += " #{piece}"
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

board = Board.new
puts board
