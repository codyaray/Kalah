module Kalah
  class RandomPlayer
    include Player
    
    def initialize(name, position, game_rules, messenger)
      super(name, position, game_rules, messenger)
    end
    
    def next_move(game_state)
      # return 0 if there are no possible moves
      if game_state.game_board.pits(position).sum == 0
        return Move.new(position,0)
      end

      pit = 1+rand(6)

      # return a valid move (not an empty pit)
      if game_state.game_board.pits(position)[pit-1] == 0
        return next_move(game_state)
      end

      Move.new(position,pit)
    end
  end
end