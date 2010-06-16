module Kalah
  class RandomPlayer
    include Player
    
    def initialize(name, position, game_rules, messenger, input=nil)
      super(name, position, game_rules, messenger)
      @input = input || STDIN
    end
    
    def next_move(game_state)
      1+rand(6)
    end
  end
end