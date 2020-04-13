require_relative './board.rb'

class Game

  class WrongInputError < StandardError; end

  class MalformedInputError < WrongInputError
    def message
      "Your Input couldn't be interpreted.
      You can enter one of the following keywords:
        'save'    to save the game
        'load'    to load an older game
        'exit'    to exit the game (!without saving!)
      A move can be entered by specifying the coordinates of the
      start- and end-square like so: 'c3:e5'."
    end
  end

  class IllegalMoveError < WrongInputError
    def message
      "The entered move is illegal.
      Are you in check? Or did you try to move into check?
      Please enter another move."
    end
  end

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
    system "clear"
    puts instructions

    standard_board_setup
    new_player_setup

    puts @board

      @players.cycle do |p|
        begin
        input = p.fetch_instructions
        puts "RECEIVED INPUT"

        m = input.match(/.*(?<save>[Ss]ave)?(?<load>[Ll]oad)?(?<exit>[Ee]xit|[qq]uit)?/)
        if !m.captures.length == 1
          puts "FOUND A KEYWORD"
          save_game if m[:save]
          load_game if m[:load]
          quit_game if m[:exit]
          #debug options
          if m[:moves]
            puts @board.prev_moves
          end
        else
          puts "FOUND NO KEYWORD"
          from, to = decode_instructions(input)
          if from == false
            puts "DIDN'T UNDERSTAND INPUT"
            raise MalformedInputError
          end

          success = @board.move_piece(from, to)
          if success == false
            puts "THE MOVE IS ILLEGAL"
            raise IllegalMoveError
          end

          system "clear"
          puts last_move(input)
          puts @board
          puts

          if @board.checkmate?(p.other_color)
            @winner = p
            break
          end
        end
      end

    rescue WrongInputError => e
      puts "RESCUING AN ERROR"
      puts e.message
      retry
    end

    puts winning_message
  end

  def new_player_setup
    @players = [Player.new(color: "w"), Player.new(color: "b")]
  end

  def standard_board_setup
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

  def instructions
    "Welcome to the Great Game of Chess!
    The Game is played between two players that each take control
    of one set of colored pieces (White and Black).
    The goal of the game is to capture the opponents King.
    If a player cannot prevent the capture of his King in the next turn, he
    or she is declared checkmate and the game ends.

    White always starts (the color on the bottom of the screen, it might look
    like another color on your screen) and every player can move one piece
    per turn. For further rules of how to play the game you better google a bit.

    To tell the game which piece you want to move where, you have to enter the
    start and end coordinates (in lowercase letters) à la 'e2:e4'.
    Castling works the same, and you can save the game at any point by
    entering 'save' or exit it by entering 'quit'.

    Now, have Fun!"
  end

  def last_move(move)
    "Last move was: #{move}"
  end

  def winning_message
    "Congratulations #{@winner.full_color}, you won!"
  end
end

