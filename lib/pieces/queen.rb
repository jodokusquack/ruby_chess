require_relative './piece.rb'

class Queen < Piece

  def to_s
    if @color == "w"
      "♕"
    else
      "♛"
    end
  end

  def possible_moves(board)
    # a queen is basically a rook and a bishop combined so to find the
    # possible moves just combine what the individual pieces do
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

    # top
    (@row + 1).upto(7) do |current_row|
      # break in the inner proc returns nil to the outer caller
      break if row_proc.call(current_row).nil?
    end

    # top right
    [7 - @col, 7 - @row].min.times do |i|
      col = @col + 1 + i
      row = @row + 1 + i
      square = board[col, row]
      if square.occupied?
        if square.piece.color == @color
          break
        else
          moves << [col, row]
          break
        end
      else
        moves << [col, row]
      end
    end

    # right
    (@col + 1).upto(7) do |current_col|
      break if col_proc.call(current_col).nil?
    end

    # bottom right
    [7 - @col, @row].min.times do |i|
      col = @col + 1 + i
      row = @row - 1 - i
      square = board[col, row]
      if square.occupied?
        if square.piece.color == @color
          break
        else
          moves << [col, row]
          break
        end
      else
        moves << [col, row]
      end
    end

    # bottom
    (@row - 1).downto(0) do |current_row|
      break if row_proc.call(current_row).nil?
    end

    # bottom left
    [@col, @row].min.times do |i|
      col = @col - 1 - i
      row = @row - 1 - i
      square = board[col, row]
      if square.occupied?
        if square.piece.color == @color
          break
        else
          moves << [col, row]
          break
        end
      else
        moves << [col, row]
      end
    end

    # left
    (@col - 1).downto(0) do |current_col|
      break if col_proc.call(current_col).nil?
    end

    # top left
    [@col, 7 - @row].min.times do |i|
      col = @col - 1 - i
      row = @row + 1 + i
      square = board[col, row]
      if square.occupied?
        if square.piece.color == @color
          break
        else
          moves << [col, row]
          break
        end
      else
        moves << [col, row]
      end
    end

    return moves
  end
end

