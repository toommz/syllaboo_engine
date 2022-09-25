# frozen_string_literal: true

RSpec.describe SyllabooEngine::GameState::Turns do
  describe "#current" do
    it "is expected to return the current player turn" do
      turns = described_class.new(players: %w[Thomas Cyrielle])

      expect(turns.current).to eq("Thomas")
    end
  end

  describe "#next" do
    it "is expected to return the next player turn" do
      turns = described_class.new(players: %w[Thomas Cyrielle])

      expect(turns.next).to eq("Cyrielle")
    end

    it "is expected not to change the current player turn" do
      turns = described_class.new(players: %w[Thomas Cyrielle]).tap(&:next)

      expect(turns.current).to eq("Thomas")
    end
  end

  describe "#next!" do
    it "is expected to return the next player turn" do
      turns = described_class.new(players: %w[Thomas Cyrielle])

      expect(turns.next!).to eq("Cyrielle")
    end

    it "is expected to change the current player turn" do
      turns = described_class.new(players: %w[Thomas Cyrielle]).tap(&:next!)

      expect(turns.current).to eq("Cyrielle")
    end
  end

  describe "#push!" do
    it "is expected to add the player at the end of the player turns" do
      turns = described_class.new(players: %w[Thomas Cyrielle])

      turns.push!("Éléanore")

      expect(turns).to eq(%w[Thomas Cyrielle Éléanore])
    end

    it "is expected not to add the player if the name is already taken" do
      turns = described_class.new(players: %w[Thomas Cyrielle])

      expect { turns.push!("Thomas") }.to raise_error(SyllabooEngine::GameState::Turns::NameAlreadyTakenError)
    end
  end

  describe "#remove!" do
    it "is expected to remove the player from the player turns" do
      turns = described_class.new(players: %w[Thomas Cyrielle])

      turns.remove!("Thomas")

      expect(turns).to eq(%w[Cyrielle])
    end

    it "is expected to raise PlayerNotFoundError if the player is not in the player turns" do
      turns = described_class.new(players: %w[Thomas])

      expect { turns.remove!("Cyrielle") }.to raise_error(SyllabooEngine::GameState::Turns::PlayerNotFoundError)
    end
  end
end
