 require_relative './piece.rb'

 class Rook < Piece

   def possible_moves(board)
     moves = []
     # left
     (@col - 1).downto(0) do |current_col|
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

     # right
     (@col + 1).upto(7) do |current_col|
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

     # up
     (@row + 1).upto(7) do |current_row|
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

     # to the bottom
     (@row - 1).downto(0) do |current_row|
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

     return moves
   end

   def to_s
     if @color == "w"
       "♖"
     else
       "♜"
     end
   end
 end
