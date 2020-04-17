require_relative './board.rb'
require_relative './turn_tracker.rb'

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

  def initialize
    @winner = false
  end

  def start
    catch :end_game do
      loop do
        catch :quit_game do
          type = ask_for_game_type
          set_up_game(type)
          play
        end
      end
    end
    puts "Thanks for playing!"
  end

  def play
    catch :game_over do
      loop do
        input = @current.fetch_instructions

        m = input.match(/((?<save>[Ss]ave)|
                          (?<load>[Ll]oad)|
                          (?<exit>[Ee]xit)|
                          (?<quit>[Qq]uit)|
                          (?<new>[Nn]ew)|
                          (?<debug>debug:)(?<option>.*))/x)
        if !m.nil?
          special_action(m)
          # since we want to keep asking for input from the same player
          # after any special action
          redo

        else
          # here we try to make an actual move
          from, to = decode_instructions(input)
          if from == false
            display_fresh_board
            puts "DIDN'T UNDERSTAND INPUT"
            puts malformed_input_message(input)
            puts
            redo
          end

          success = @board.move_piece(from, to)
          if success == false
            display_fresh_board
            puts "THE MOVE IS ILLEGAL"
            puts illegal_move_message(input)
            puts
            redo
          end

          # after a new move the game is not saved again
          @saved = false

          # display the new board and the last played move
          display_fresh_board

          # check if the game has ended
          if @board.checkmate?(@current.other_color)
            puts "CHECKMATE"
            @winner = p
            throw :game_over
          end
        end

        # after a move make it the next player's turn
        @current = @tracker.next
      end
    end

    @game_in_play = false
    puts winning_message
    ask_to_continue
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

  private

  def special_action(match)
    if    match[:save]
      save_game
    elsif match[:exit]
      exit_game
    elsif match[:quit]
      quit_game
    elsif match[:load] or match[:new]
      confirmed = confirm_quit
      if confirmed
        type = select_saved_game  if match[:load]
        type = "new"              if match[:new]
        set_up_game(type)
      end
    elsif match[:debug]
      #debug options
      case match[:option]
      when "prev_moves"
        puts @board.prev_moves
        puts "Total moves: #{@board.prev_moves.length}"
      when "white_moves"
        @board.white_pieces.each do |p|
          print p
          print p.position
          print ": "
          print p.legal_moves(@board)
          puts
        end
      when "black_moves"
        @board.black_piece.each do |p|
          print p
          print p.position
          print ": "
          print p.legal_moves(@board)
          puts
        end
      when "checkmate"
        @winner = @current
        throw :game_over
      when "remis"
        throw :game_over
      else
        puts "No recognized debug option."
        puts "'prev_moves', 'white_moves', 'black_moves'"
      end
    end
  end

  def ask_for_game_type
    system "clear"
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

    return "new"              if input == "new"
    return select_saved_game  if input == "load"
    exit_game                 if input == "exit"
  end

  def set_up_game(name)
    # this function sets up a game, either a new one or a saved one
    @game_in_play = true
    system "clear"

    if name == "new"
      puts instructions

      # sets up @board
      standard_board_setup
      # sets up @tracker with a new @players array
      player_setup(players: "new", current_color: "w")
      @current = @tracker.current
      @saved = false

    else
      # load the game with the name name
      # it needs to setup:
      # @board
      # @current
      # @tracker
      # @saved
      # @players
    end

    puts @board
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

  def player_setup(players:, current_color:)
    # this method creates an @players array and sets up a TurnTracker
    # with it
    if players == "new"
      @players = [Player.new(color: "w"), Player.new(color: "b")]
      @tracker = TurnTracker.new(players: @players)
    else
      @players = players
      @tracker = TurnTracker.new(players: @players,
                                 current_color: current_color)
    end
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


  def malformed_input_message(input)
    "
    '#{input}' couldn't be interpreted.
    You can enter one of the following keywords:
      'save'    to save the game
      'load'    to load an older game
      'quit'    to return to the start screen
      'exit'    to exit the game (!without saving!)

    A move can be entered by specifying the coordinates of the
    start- and end-square like so: 'c3:e5'.
"
  end


  def illegal_move_message(move)
    "
    The move '#{move}' is illegal.
    Are you in check? Or did you try to move into check?
    Or maybe it was just a typo.

    Please try entering another move.
"
  end

  def last_move
    lm = @board.last_move
    if lm.piece == "New Game"
      ""
    else
      "Last move was: #{lm}"
    end
  end

  def display_fresh_board
    system "clear"
    puts
    puts last_move
    puts @board
    puts
  end

  def winning_message
    if @winner != false
      "Congratulations! #{@winner.full_color} won!"
    else
      "Remis! The game has ended without a winner."
    end
  end

  def ask_to_continue
    puts "Do you want to play another round? :) [Y/n]"

    input = gets.chomp.downcase

    if input[0] == "n"
      throw :end_game
    end
  end

  def select_saved_game
    puts "LOADING..."
    puts "CHOOSING NEW GAME FOR NOW"
    # show previously saved games
    # show warning if no games were found
    # display options for loading any of
    # the saved games, or start a new one.
    #
    # return either the name of a saved game or "new"
    # for now:
    return "new"
  end

  def save_game
    puts "SAVING..."
    # ask for the save slot (max 3) or
    # which one to overwrite
    #
    # save and set @saved to true
    @saved = true
    #
    # ask if want to continue
  end

  def exit_game
    confirmed = confirm_quit
    if confirmed
      @game_in_play = false
      throw :end_game
    end

    puts "'Quit Game' cancelled. Returning to previous game."
    puts
    return
  end

  def quit_game
    confirmed = confirm_quit
    if confirmed
      @game_in_play = false
      throw :quit_game
    end
  end

  def confirm_quit
    return true if !@game_in_play or @saved

    puts "
            !!WARNING!!
    The current game is not saved!
    You will lose all progress if you continue without saving.

    Do you really want to continue? [y/N]"

    input = gets.chomp.downcase

    if input[0] == "y"
      true
    else
      display_fresh_board
      false
    end
  end
end

