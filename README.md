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

