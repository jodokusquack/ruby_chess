require './lib/game.rb'

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

  describe "#start" do
    it "presents the players with a few options for play" do
      game = Game.new
      allow(game).to receive(:gets).and_return("new\n")
      allow(game).to receive(:new_standard_game)

      expect { game.start }.to output(/new.*load/im).to_stdout
    end

    it "keeps asking if the user inputs something invalid" do
      game = Game.new
      allow(game).to receive(:gets).and_return("\n", "alköj asdlf\n", "load\n")
      allow(game).to receive(:load_game)

      game.start

      expect(game).to have_received(:load_game)
    end

    it "can start a new game" do
      game = Game.new
      allow(game).to receive(:gets).and_return("new\n")
      allow(game).to receive(:new_standard_game)

      game.start

      expect(game).to have_received(:new_standard_game)
    end

    it "can exit the game" do
      game = Game.new
      allow(game).to receive(:gets).and_return("exit\n")
      allow(game).to receive(:exit_game)

      game.start

      expect(game).to have_received(:exit_game)
    end
  end
end
