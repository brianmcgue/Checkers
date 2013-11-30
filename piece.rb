# -*- coding: utf-8 -*-
class Piece
  attr_accessor :pos, :color, :promoted, :board

  def initialize(pos, color, board)
    @pos, @color, @promoted, @board = pos, color, false, board
  end

  MOVES = [[ 1, 1],
           [ 1,-1],
           [ 2, 1],
           [ 2,-2],]

  def moves
    moves = []
    mod = (@color = :black ? 1 : -1)
    MOVES.each do |add|
      move = [@pos[0] + add[0] * mod, @pos[1] + add[1]]
      moves << move if open_spot?(move)
    end
    if @promoted
      MOVES.each do |add|
        move = [@pos[0] - add[0] * mod, @pos[1] + add[1]]
        moves << move if open_spot?(move)
      end
    end
  end

  def open_spot?(move)
    move.min >= 0 && move.max < 11 && @board.empty?(move)
  end

  def to_s
    if @promoted
      @color == :black ? "\u2617" : "\u2616"
    else
      @color == :black ? "⚫" : "⚪"
    end
  end
end