require_relative './piece.rb'

class Knight < Piece

  def to_s
    if @color == "w"
      "♘"
    else
      "♞"
    end
  end

  def possible_moves(board)
    moves = []

    reachable = [
      [@col + 1, @row + 2],
      [@col + 2, @row + 1],
      [@col + 2, @row - 1],
      [@col + 1, @row - 2],
      [@col - 1, @row - 2],
      [@col - 2, @row - 1],
      [@col - 2, @row + 1],
      [@col - 1, @row + 2]
    ]

    reachable.each do |position|
      next if board[*position].nil?
      next if board[*position].occupied? and board[*position].piece.color == @color

      moves << position
    end

  return moves
  end
end
