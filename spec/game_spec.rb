require './lib/game.rb'
require 'stringio'

RSpec.describe Game do
  describe "#decode_instructions" do
    context "when the instructions are given as 'from' and 'to' coordinates" do

      it "can decode the instructions" do
        game = Game.new

        from, to = game.decode_instructions("a2g3")

        expect(from).to eq [0, 1]
        expect(to).to eq [6, 2]
      end

      it "can decode the instructions if there is a space in the middle" do
        game = Game.new

        from, to = game.decode_instructions("b4 h6")

        expect(from).to eq [1, 3]
        expect(to).to eq [7, 5]
      end

      it "can decode the instructions if there is a colon in the middle" do
        game = Game.new

        from, to = game.decode_instructions("b6:d3")

        expect(from).to eq [1, 5]
        expect(to).to eq [3, 2]
      end

      it "returns false on incorrectly formatted input" do
        game = Game.new

        from, to = game.decode_instructions("2,d3")

        expect(from).to eq false
        expect(to).to eq false
      end

      it "returns false when the input is out of bounds" do
        game = Game.new

        from, to = game.decode_instructions("t5:a4")

        expect(from).to eq false
        expect(to).to eq false
      end
    end
  end

  describe "a whole_game" do

    after(:each) do
      $stdin = STDIN
    end

    it "can play the Fool's Mate" do
      # first create a new stdin
      io = StringIO.new
      io.puts "new"
      io.puts "f2f3"
      io.puts "e7e5"
      io.puts "g2g4"
      io.puts "d8h4"
      io.puts "n"
      io.rewind

      $stdin = io

      game = Game.new
      allow(game).to receive(:gets).and_return(io.gets)

      expect { game.start }.to output(/Congratulations!/).to_stdout
    end
  end
end
