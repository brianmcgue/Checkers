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
      if valid_move?([@pos[0] + add[0] * mod,@pos[1] + add[1]])
        moves << [@pos[0] + add[0] * mod,@pos[1] + add[1]]
      end
    end
    if @promoted
      MOVES.each do |add|
        if valid_move?([@pos[0] - add[0] * mod,@pos[1] + add[1]])
          moves << [@pos[0] - add[0] * mod,@pos[1] + add[1]]
        end
      end
    end
  end

  def valid_move?(move)
    return false if move.min < 0 || move.max > 9 ||
                    !@board.grid[move[0]][move[1]].nil?
    true
  end

  def to_s
    if @promoted
      @color == :black ? "\u2617" : "\u2616"
    else
      @color == :black ? "\u2688" : "\u2686"
    end
  end
end