require_relative './piece.rb'

class Rook < Piece

  def to_s
    if @color == "w"
      "♖"
    else
      "♜"
    end
  end

  def possible_moves(board)
    moves = []

    row_proc = lambda do |current_row|
      square = board[@col, current_row]
      if square.occupied?
        if square.piece.color == @color
          break
        else
          moves << [@col, current_row]
          break
        end
      else
        moves << [@col, current_row]
      end
    end

    col_proc = lambda do |current_col|
      square = board[current_col, @row]
      if square.occupied?
        if square.piece.color == @color
          break
        else
          moves << [current_col, @row]
          break
        end
      else
        moves << [current_col, @row]
      end
    end

    # left
    (@col - 1).downto(0) do |current_col|
      # break in the inner proc returns nil to the outer caller
      break if col_proc.call(current_col).nil?
    end

    # right
    (@col + 1).upto(7) do |current_col|
      break if col_proc.call(current_col).nil?
    end

    # up
    (@row + 1).upto(7) do |current_row|
      break if row_proc.call(current_row).nil?
    end

    # to the bottom
    (@row - 1).downto(0) do |current_row|
      break if row_proc.call(current_row).nil?
    end

    return moves
  end
end
