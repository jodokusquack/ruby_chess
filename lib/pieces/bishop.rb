require_relative './piece.rb'

class Bishop < Piece
  def to_s
    if @color == "w"
      "♗"
    else
      "♝"
    end
  end

  def possible_moves(board)
    moves = []

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
