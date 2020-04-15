require_relative './piece.rb'

class King < Piece
  def to_s
    if @color == "w"
      "♚"
    else
      "♔"
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

  def legal_moves(board)
    # the king has a special legal_moves section, since he is not allowed
    # to move into check, but has to move out of check if he is.
    # That means we have just have to skip the shortcut if the piece is
    # not in check, and always check if the king would be in check after
    # the move.
    reachable = possible_moves(board)

    legal = []

    reachable.each do |square|
      board.move_piece_to_possible(@position, square)

      legal << square if !board.check?(@color)

      board.take_back_turn
    end

    return legal
  end
end

