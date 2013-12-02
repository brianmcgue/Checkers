# -*- coding: utf-8 -*-
class Piece
  attr_accessor :pos, :promoted
  attr_reader :color, :board

  def initialize(pos, color, board, promoted = false)
    @pos, @color, @board, @promoted = pos, color, board, promoted
  end

  MOVES = [
    [ 1, 1],
    [ 1,-1],
    [ 2, 2],
    [ 2,-2]
  ]

  def moves
    direction_modifier = (self.color == :black ? 1 : -1)
    promoted_modifier = direction_modifier * -1
    moves = MOVES.map do |move|
      i, j = self.pos
      move_i, move_j = move
      [i + move_i * direction_modifier, j + move_j]
    end
    if self.promoted?
      moves += MOVES.map do |move|
        i, j = self.pos
        move_i, move_j = move
        [i + move_i * promoted_modifier, j + move_j]
      end
    end
    moves.select { |move| move.min >= 0 && move.max < Board::BOARDSIZE }
  end

  def promoted?
    @promoted
  end

  def to_s
    if self.promoted?
      self.color == :black ? "☗" : "☖"
    else
      self.color == :black ? "⚫" : "⚪"
    end
  end
end