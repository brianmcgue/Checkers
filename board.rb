require 'colorize'
require_relative 'piece'
require_relative 'invalid'

class Board
  attr_reader :grid

  BOARDSIZE = 6

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
    BOARDSIZE.times do |row|
      BOARDSIZE.times do |col|
        pos = [row, col]
        next if empty?(pos)
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
    diff = [(start[0]-finish[0]).abs, (start[1]-finish[1]).abs]
    empty?(start) || empty?(jump) || !empty?(finish) || diff != [2, 2] ||
    self[start].color == self[jump].color || !self[start].moves.include?(finish)
  end

  def invalid_slide(start, finish)
    diff = [(start[0]-finish[0]).abs, (start[1]-finish[1]).abs]
    empty?(start) || !empty?(finish) || diff != [1, 1] ||
    !self[start].moves.include?(finish)
  end

  def maybe_promote?(piece)
    back_row = (piece.color == :black ? (BOARDSIZE - 1) : 0)
    piece.promoted = true if piece.pos[0] == back_row
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
    unless valid_move_seq?(move_seq)
      raise InvalidMoveError.new "Problem performing move sequence."
    end
    perform_moves!(move_seq)
  end

  def perform_moves!(move_seq)
    if move_seq.count == 2
      unless perform_slide(*move_seq) || perform_jump(*move_seq)
        raise InvalidMoveError.new "Invalid slide or jump."
      end
    else
      move_seq.each_index do |idx|
        next if idx == move_seq.count - 1
        unless perform_jump(*move_seq[idx..idx+1])
          raise InvalidMoveError.new "Invalid sequence of jumps."
        end
      end
    end
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
    BOARDSIZE.times do |row|
      output += "#{row}"
      BOARDSIZE.times do |col|
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
      false
    else
      true
    end
  end

  private
  def make_board(fill_board)
    @grid = Array.new(BOARDSIZE){Array.new(BOARDSIZE){nil}}
    if fill_board
      BOARDSIZE.times do |row|
        next if row.between?((BOARDSIZE/2 - 1), (BOARDSIZE/2))
        color = (row < (BOARDSIZE/2 - 1) ? :black : :white)
        BOARDSIZE.times do |col|
          next unless row.odd? ^ col.odd?
          pos = [row, col]
          self[pos] = Piece.new(pos, color, self)
        end
      end
    end
  end
end