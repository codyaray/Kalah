module Kalah
  class MinimaxPlayer
    include Player
    
    INFINITY  = 1.0/0.0
    MAX_DEPTH = 4
    
    attr_accessor :num_states_evaluated
    
    def initialize(name, position, game_rules, messenger)
      super(name, position, game_rules, messenger)
    end
    
    def next_move(game_state)
      minimax(game_state, MAX_DEPTH)
    end

    # Find the best move in the game_state, looking ahead depth moves.
    # 
    # The game_state must support the following functions:
    # dup() to make a deep copy of the game
    # score() a naive utility fn for non-terminal positions,
    #         but precise for terminal positions
    # apply_move() to modify the game state by applying an operator
    # 
    # depth  the number of moves of lookahead 0=> no lookahead
    # 
    # eval_fn instead of using the default game.eval(),
    #         to be used only for non-terminal positions
    def minimax(game_state, depth, eval_fn = nil)
      @num_states_evaluated = 1
      best = nil

      # try each move
      @game_rules.legal_moves(game_state).each do |move|
        # g = game_state.dup
        g = game_state.apply_move(move)
        # evaluate the position and choose the best move
        # NOTE: the minimax function computes the value for the current
        # player which is the opponent so we need to invert the value
        val = -1 * minimax_value(g, depth, eval_fn)
        # update the best operator so far
        if best == nil or val > best[0]
          best = [val, move]
        end
      end
      
      best[1]
    end

    # Find the utility value of the game_state w.r.t. the current player
    def minimax_value(game_state, depth, eval_fn = nil)
      @num_states_evaluated += 1

      # if we have reached the maximum depth, the utility is approximated
      # with the evaluation function
      if depth == 0 or @game_rules.is_over?(game_state)
        if eval_fn
          return eval_fn.call(game_state)
        else
          return game_state.score(position)
        end
      end
      
      best = nil
      
      # try each move
      @game_rules.legal_moves(game_state).each do |move|
        # g = game_state.dup
        g = game_state.apply_move(move)
        # evaluate the position and choose the best move
        # NOTE: the minimax function computes the value for the current
        # player which is the opponent so we need to invert the value
        val = -1 * minimax_value(g, depth-1, eval_fn)
        if best == nil or val > best
          best = val
        end
      end

      best
    end
  end        
end