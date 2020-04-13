require_relative './board.rb'

class Game

  LETTER_TO_NUMBERS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7,
  }

  def decode_instructions(instructions)
    m = instructions.match(/.*(?<from>[a-h][1-8]).*(?<to>[a-h][1-8]).*/)

    return false, false if m.nil? or m.captures.length != 2

    from_col = LETTER_TO_NUMBERS[m[:from][0]]
    from_row = m[:from][1].to_i - 1

    from = [from_col, from_row]

    to_col = LETTER_TO_NUMBERS[m[:to][0]]
    to_row = m[:to][1].to_i - 1

    to = [to_col, to_row]

    return from, to
  end

  def new_standard_game
    # instructions
    standard_game_setup

    puts @board

    @players.cycle do |p|
      input = p.fetch_instructions

      # input interpretation
      # if 'save' ...
      # if 'exit' or 'quit' ...
      # else from, to = @board.decode_instructions(input)
      # success = board.move_piece(from, to)
      # if success == false
      #   print warning, this should maybe be handled in the move
      #   function
      # repeat until success == true

      system "clear"
      puts input
      puts @board

      if board.checkmate?
        @winner = p
        break
      end
    end

    puts winning_message
  end

  def standard_game_setup
    @board = Board.new

    pieces = [:Rook, :Knight, :Bishop, :Queen, :King, :Bishop, :Knight, :Rook]

    8.times do |i|
      # pawns
      [[1, "w"], [6, "b"]].each do |el|
        @board.place_piece([i, el[0]], piece: :Pawn, color: el[1])
      end

      # white pieces
      @board.place_piece([i, 0], piece: pieces[i], color: "w")

      # black pieces
      @board.place_piece([i, 7], piece: pieces[i], color: "b")
    end

    @board
  end
end

