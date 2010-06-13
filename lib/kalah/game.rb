module Kalah
  class Game
    def initialize(messenger)
      @messenger = messenger
    end

    def start
      @messenger.puts "Welcome to Kalah!"
      @messenger.puts "Select pit for sowing:"
    end
  end
end