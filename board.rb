require 'colorize'
require_relative 'piece'
require_relative 'invalid'

class Board
  def initialize(fill_board = true)
    make_board(fill_board)
  end

  def [](pos)
    i, j = pos
    @grid[i][j]
  end

  def []=(pos, piece)
    i, j = pos
    @grid[i][j] = piece
  end

  def dup
    board_dup = Board.new(false)
    10.times do |row|
      10.times do |col|
        pos = [row, col]
        piece = self[pos]
        board_dup[pos] = Piece.new(pos, piece.color, board_dup, piece.promoted?)
      end
    end
    board_dup
  end

  def empty?(pos)
    self[pos].nil?
  end

  def invalid_jump(start, jump, finish)
    empty?(start) || empty?(jump) || !empty?(finish) ||
    self[start].color == self[jump].color || !self[start].moves.include?(finish)
  end

  def invalid_slide(start, finish)
    empty?(start) || !empty?(finish) ||
    !self[start].moves.include?(finish)
  end

  def maybe_promote?(piece)
    back_row = (piece.color == :black ? 9 : 0)
    piece.promote = true if piece.pos[0] == back_row
  end

  def perform_jump(start,finish)
    jump = [(start[0] + finish[0])/2, (start[1] + finish[1])/2]

    return false if invalid_jump(start, jump, finish)

    self[finish], self[start], self[jump] = self[start], nil, nil
    self[finish].pos = finish
    maybe_promote?(self[finish])
    true
  end

  def perform_moves(move_seq)
    perform_moves!(move_seq) if valid_move_seq?(move_seq)
  end

  def perform_moves!(move_seq)

  end

  def perform_slide(start,finish)
    return false if invalid_slide(start, finish)

    self[finish], self[start] = self[start], nil
    self[finish].pos = finish
    maybe_promote?(self[finish])
    true
  end

  def to_s
    output = " 0 1 2 3 4 5 6 7 8 9\n"
    10.times do |row|
      output += "#{row}"
      10.times do |col|
        pos = [row, col]
        bg = (row.odd? ^ col.odd? ? :white : :light_white)
        if self.empty?(pos)
          output += "  ".colorize(:color => :black, :background => bg)
        else
          output += "#{self[pos]} ".colorize(:color => :black, :background => bg)
        end
      end
      output += "\n"
    end
    output
  end

  def valid_move_seq?(move_seq)
    begin
      board_dup = self.dup
      board_dup.perform_moves!(move_seq)
    rescue InvalidMoveError
      puts "You've made an invalid move."
      false
    else
      true
    end
  end

  private
  def make_board(fill_board)
    @grid = Array.new(10){Array.new(10){nil}}
    if fill_board
      10.times do |row|
        next if row.between?(4,5)
        color = (row < 4 ? :black : :red)
        10.times do |col|
          next unless row.odd? ^ col.odd?
          pos = [row, col]
          self[pos] = Piece.new(pos, color, self)
        end
      end
    end
  end
end

# board = Board.new
# puts board