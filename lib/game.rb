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

  MalformedInputMessage = "
      Your Input couldn't be interpreted.
      You can enter one of the following keywords:
        'save'    to save the game
        'load'    to load an older game
        'exit'    to exit the game (!without saving!)
      A move can be entered by specifying the coordinates of the
      start- and end-square like so: 'c3:e5'."

  IllegalMoveMessage = "
      The entered move is illegal.
      Are you in check? Or did you try to move into check?
      Please enter another move."

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

  def initialize
    @game_in_play = false
    @saved = false
    @winner = false
  end

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

  def start
    puts "
    Welcome to Chess! What would you like to do?

      * Start a new Game  ->  Enter 'new'
      * Load a saved Game ->  Enter 'load'

      * Exit              ->  Enter 'exit'
    "

    allowed = ["new", "load", "exit"]
    input = ""

    loop do
      input = gets.chomp.downcase
      if allowed.include?(input)
        break
      end
    end

    new_standard_game if input == "new"
    load_game         if input == "load"
    exit_game         if input == "exit"
  end

  def new_standard_game
    @game_in_play = true
    system "clear"
    puts instructions

    standard_board_setup
    new_player_setup

    puts @board

    @players.cycle do |p|
      catch :game_over do
        1.times do
          input = p.fetch_instructions
          puts "RECEIVED INPUT"

          # FIXME the Regex
          m = input.match(/((?<save>[Ss]ave)|(?<load>[Ll]oad)|(?<exit>[Ee]xit|[Qq]uit)|(?<debug>debug: )(?<option>.*))/)
          if !m.nil?
            puts "FOUND A KEYWORD"
            save_game if m[:save]
            load_game if m[:load]
            exit_game if m[:exit]
            #debug options
            if m[:debug]
              case m[:option]
              when "prev_moves"
                puts @board.prev_moves
              when "white_moves"
                @board.white_pieces.each do |p|
                  print p
                  print p.position
                  print ": "
                  print p.legal_moves(@board)
                  puts
                end
              when "black_pieces"
                @board.black_piece.each do |p|
                  print p
                end
              else
                puts "No recognized debug option."
              end
            end

            # since we want to keep asking for input from the same player
            # after saving or aborting an exit we retry
            redo
          else
            puts "FOUND NO KEYWORD"
            from, to = decode_instructions(input)
            if from == false
              puts "DIDN'T UNDERSTAND INPUT"
              puts MalformedInputMessage
              redo
            end

            success = @board.move_piece(from, to)
            if success == false
              puts "THE MOVE IS ILLEGAL"
              puts IllegalMoveMessage
              redo
            end

            system "clear"
            puts last_move(input)
            puts @board
            puts

            if @board.checkmate?(p.other_color)
              puts "CHECKMATE"
              @winner = p
              throw :game_over
            end
          end
        end
      end
    end

    puts winning_message
    @game_in_play = false
  end

  def load_game
    puts "LOADING..."
    # show previously saved games
    # show warning if no games were found
    # display options for loading any of
    # the saved games, or start a new one.
    #
    # call either new_standard_game or
    # load_saved_game

  end

  def save_game
    puts "SAVING..."
    # ask for the save slot (max 3) or
    # which one to overwrite
    #
    # save and set @saved to true
    #
    # ask if want to continue
  end

  def exit_game
    if @game_in_play and !@saved
      puts "
      The current game is not saved!
      You will lose all progress if you exit without saving.

      Do you really want to exit without saving? [y/N]"

      input = gets.chomp.downcase

      if input[0] != "y"
        return
      end
    end

    abort("Thanks for playing!")

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
    "
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
    if @winner != false
      "
      Congratulations #{@winner.full_color}, you won!"
    else
      "
      Remis! The game has ended without a winner."

    end
  end
end

