# frozen_string_literal: true

module SyllabooEngine
  module GameState
    # Player turns behaviour providing useful methods as #next, #current.
    class Turns
      include Enumerable

      class NameAlreadyTakenError < StandardError; end
      class PlayerNotFoundError < StandardError; end

      START_INDEX = 0
      INDEX_GAP = 1

      def initialize(players: [])
        @players = players
        @current_index = START_INDEX
        @max = @players.length - INDEX_GAP
      end

      def each(&block)
        if block_given?
          players.each(&block)
        else
          to_enum(:each)
        end
      end

      def current = to_a.at(current_index)
      def next = to_a.at(next_index)

      def next!
        self.current_index = next_index
        current
      end

      def push!(player)
        raise NameAlreadyTakenError if player_already_present?(player)

        players << player
      end

      def remove!(player)
        raise PlayerNotFoundError unless player_already_present?(player)

        reject(&player.method(:==))
      end

      def ==(other)
        other == players
      end

      private

      attr_accessor :current_index
      attr_reader :players, :max

      def last_turn? = current_index >= max
      def next_index = last_turn? ? START_INDEX : (current_index + INDEX_GAP)

      def player_already_present?(player)
        find(&player.method(:==))
      end
    end
  end
end
