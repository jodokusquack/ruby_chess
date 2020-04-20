require_relative './piece.rb'

class Pawn < Piece

  def to_s
    if @color == "w"
      "♟"
    else
      "♙"
    end
  end

  def possible_moves(board)
    moves = []
    if @color == "w"
      method = :+
      home_row = 1
      other_color = "b"
    else
      method = :-
      home_row = 6
      other_color = "w"
    end

    # first check the square ahead of the pawn
    s1 = [@col, @row.send(method, 1)]
    if s1[1] >= 0 and s1 [1] <= 7
      if !board[*s1].occupied?
        moves << s1
        # and if it is the home row, also check the next one
        if @row == home_row
          s2 = [@col, @row.send(method, 2)]
          moves << s2 unless board[*s2].occupied?
        end
      end

      # next check the two squares diagonally
      possible = [
        [@col + 1, @row.send(method, 1)],
        [@col - 1, @row.send(method, 1)]
      ]
      possible.each do |s|
        next if s.any? { |el| el > 7 or el < 0 }
        moves << s if board[*s].occupied? and board[*s].piece.color != @color
      end
    end

    # finally check en passant
    if board.last_move.en_passant?
      other_pos = board.last_move.to
      # if the two pawn in question are next to each other
      if @row == other_pos[1] and (@col - other_pos[0]).abs == 1
        moves << [@col - (@col - other_pos[0]), @row.send(method, 1)]
      end
    end

    return moves

  end

  def promote
    pieces = {
      q: :Queen,
      r: :Rook,
      b: :Bishop,
      k: :Knight
    }

    if @color == "w"
      q = "♛"
      r = "♜"
      b = "♝"
      k = "♞"
    else
      q = "♕"
      r = "♖"
      b = "♗"
      k = "♘"
    end

    puts"What do you want to promote to?
( 'Q': #{q} | 'R': #{r} | 'B': #{b} | 'K': #{k} )"

    allowed = ["q", "r", "b", "k"]
    input = ""
    loop do
      input = gets.chomp.downcase
      break if allowed.include?(input)
    end

    return pieces[input.to_sym]
  end
end
