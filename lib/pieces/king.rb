require_relative './piece.rb'

class King < Piece
  def to_s
    if @color == "w"
      "♔"
    else
      "♚"
    end
  end

  def possible_moves(board)
    # the king can move one square in any direction
    moves = []

    reachable = [
      [@col, @row + 1],
      [@col + 1, @row + 1],
      [@col + 1, @row],
      [@col + 1, @row - 1],
      [@col, @row - 1],
      [@col - 1, @row - 1],
      [@col - 1, @row],
      [@col - 1, @row + 1]
    ]

    reachable.each do |position|
      next if board[*position].nil?
      next if board[*position].occupied? and board[*position].piece.color == @color

      moves << position
    end

    return moves
  end
end

