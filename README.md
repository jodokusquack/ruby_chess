# Chess

## The Project
This is the final project from [The Odin Project's](https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project?ref=lnav)
Ruby Learning Track. I tried to recreate the game chess on the command line
from scratch with Object Oriented Programming and Testdriven Development.

I tried to include a lot of tests for the smaller methods but in the end
didn't include many different tests for whole games. (I just check the very basic
Fool's Mate)

The Code still includes some of the functionalities I wrote for debugging, like
two special starting positions to test castling and promoting.
Feel free to check out the code to see how I tackled this project.
If you do, here is a short rundown of the structure:

- The chess.rb file is just a short script that loads the Game class, creates a Game and calls Game.start
- The Game class handles starting a new game, loading, saving and exiting.
    - Most of the input processing is happening here, so the Game class tries to decode what the player has entered
- The Board class consists of a 8*8 matrix of Squares which can all hold a single playing piece.
    - Movement and capturing are both handled by the move_piece method of the Board class
    - All previous moves are recorded as instances of a Move class in the prev_moves array
    - Check is determined by checking if any of the other players pieces can reach King
    - Checkmate is determined by seeing if any of the own pieces have any legal moves left.
        - This is also the case with a stalemate, so the Game class also checks for check if checkmate is true
- All indicidual pieces inherit from the Piece class, which sets a few instance_attributes and methods shared by all pieces
    - Each individual piece class (e.g. the Rook class) has its own possible_moves method which returns an array of all squares that are theoretically reachable
    - However for determining the legal_moves, the piece still has to check if it's King would be in check after the move
    - This is done by doing the move, checking for check and then taking back the move via the Board's take_back_turn method
    - Because the piece has to have knowledge of the board for determining the legal moves, the board has to be passed as an argument to the possible_moves method
- The Game class also spawns an instance of a TurnTracker class which holds an array of both players and has a next method, which returns the player whose turn it is next

If you have any suggestions on how I could improve the code, feel free to
create a Pull request and I'll check it out.

## The Rules
Chess is a 2-player Game where your goal is to checkmate your opponent, which
means to trap the enemy king, so that it cannot move anymore without getting
captured in the next move.

For a complete set of rules about how each piece can move over the board, I
would suggest a Google search because there are in fact quite a few rules to
this game.

During the game you can always type:

    * "save" to save the game
    * "new"  to start a new game
    * "quit" to exit the current game
    * "exit" to exit the program

## How to play
To play the game, clone this repo onto your own machine:

`git clone https://github.com/jodokusquack/ruby_chess.git`

Then execute `chess.rb` by entering `./chess.rb`.
You should of course first check the contents of the file before executing any
file that you got from the Internet.

Thanks for playing! :)

