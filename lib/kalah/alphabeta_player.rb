module Kalah
  class AlphabetaPlayer
    include Player
    
    INFINITY  = 1.0/0.0
    MAX_DEPTH = 3
    
    attr_accessor :num_states_evaluated, :depth_achieved
    
    def initialize(name, position, game_rules, messenger, eval_fn = nil)
      super(name, position, game_rules, messenger)
      @eval_fn = eval_fn
    end
    
    def next_move(game_state)
      @depth_achieved = MAX_DEPTH
      alphabeta(game_state, MAX_DEPTH)
    end
    
    # Find the best move in the game_state, looking ahead depth moves.
    # 
    # Returns a tuple (estimated value, move)
    # The game_state must support the following functions:
    # 
    #     copy() to make a deep copy of the game_state
    #     score() a naive utility fn for non-terminal positions,
    #            but precise for terminal positions
    #     terminal_test() to determine whether the game is over
    #     generate_moves() to return a list of legal moves in the current
    #                      game state
    #     play_move() to modify the game state by applying an operator
    # 
    # depth  the number of moves of lookahead 0=> no lookahead
    # 
    # eval_fn instead of using the default game.eval(),
    #         to be used only for non-terminal positions
    def alphabeta(game_state, depth, eval_fn = nil)
      @num_states_evaluated = 1
      best = nil # 2-elem array [val, move]

      # try each move    
      @game_rules.legal_moves(game_state).each do |move|
        g = game_state.apply_move(move)
        # evaluate the position and choose the best move
        # NOTE: the minimax function computes the value for the current
        # player which is the opponent so we need to invert the value
        # the -ve of my best val is the opponent's beta value
        if best != nil
          opp_beta = -1 * best[0]
        else
          opp_beta = nil
        end

        val = -1 * alphabeta_value(g, depth, nil, opp_beta, eval_fn, move)
        # update the best operator so far
        if best == nil or val > best[0]
          best = [val, move]
        end
      end

      best[1]
    end

    # Find the utility value of the game w.r.t. the current player.
    # 
    # alpha = nil => -inf
    # beta = nil => +inf
    def alphabeta_value(game_state, depth, alpha, beta, eval_fn = nil, move = nil)
      @num_states_evaluated += 1

      # if we have reached the maximum depth, the utility is approximated
      # with the evaluation function
      if depth == 0 or @game_rules.is_over?(game_state)
        if eval_fn
          return eval_fn.call(game_state, move)
        else
          return game_state.score(position)
        end
      end

      # try each move
      @game_rules.legal_moves(game_state).each do |move|
        g = game_state.apply_move(move)
        # evaluate the position and choose the best move
        # NOTE: the minimax function computes the value for the current
        # player which is the opponent so we need to invert the value
        # invert alpha beta values and meaning, think of the following
        #     alpha <=  my score <=  beta
        # => -alpha >= -my score >= -beta
        # => -alpha >= opp score >=  beta
        # => -beta  <= opp score <= -alpha
        if beta != nil
          opp_alpha = -1 * beta
        else
          opp_alpha = nil
        end

        if alpha != nil
          opp_beta = -1 * alpha
        else
          opp_beta = nil
        end
        
        val = -1 * alphabeta_value(g, depth-1, opp_alpha, opp_beta, eval_fn, move)

        # update alpha (current player's low bound)
        if alpha == nil or val > alpha
          alpha = val
        end

        # prune using the alpha-beta condition
        if (alpha != nil) and (beta != nil) and alpha >= beta
          # I suppose we could return alpha here as well
          return beta
        end
      end
      
      # alpha is my best score
      alpha
    end
  end        
end