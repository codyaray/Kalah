module Kalah
  class Referee
    
    attr_accessor :game_state, :player_pos, :player_neg, :fmt_file
    
    def initialize(player_pos, player_neg, game_rules, max_moves, messenger=STDOUT)
      @player_pos = player_pos
      @player_neg = player_neg
      @game_rules = game_rules
      @max_moves = max_moves
      @messenger = messenger
      
      @game_rules.referee = self

      @fmt_file = true
      trap("INT") { @messenger.puts ":::Quitting:::"; exit }
    end    

    def start_game(game_board="6 6 6 6 6 6  6 6 6 6 6 6  0 0")
      @game_state = Kalah::GameState.new(game_board)
      
      unless @fmt_file
        @messenger.puts "Welcome to Kalah!"
        @messenger.puts @game_state.to_s
        @messenger.puts "Select pit for sowing:"
      end
    end
    
    def start_game_from_file(game_id)
      file = File.join(File.dirname(__FILE__), "..", "..", "games", game_id+".kalah")
      
      begin
        game_file = File.new(file, "r")
  	  rescue => err
  	    raise Kalah::SavedGameError, "Missing game file: #{game_id}"
	    end
	    
      @player_pos.name = game_file.gets.strip
      @player_neg.name = game_file.gets.strip
      @player_pos.position = game_file.gets.strip.downcase.to_sym
      @player_neg.position = game_file.gets.strip.downcase.to_sym
      
      @messenger.puts @player_pos.name, @player_neg.name,
        @player_pos.position.to_s.upcase, @player_neg.position.to_s.upcase if @fmt_file
      
      start_game(board = game_file.gets.strip)
      @messenger.puts board if @fmt_file
      while (pit = game_file.gets and board = game_file.gets.strip)
        pit = pit.strip.to_i

        begin
          next_move = ((@game_state.turn == 1) ? Move.new(@player_pos.position,pit) : Move.new(@player_neg.position,pit))
      	  @game_state = @game_state.apply_move(next_move)
      	  @messenger.puts pit, @game_state.to_s if @fmt_file
        rescue => err
          raise Kalah::SavedGameError, "Corrupt game file: #{err.inspect}"
        end
      
    	  if @game_state.to_s != board
    	    raise Kalah::SavedGameError, "Corrupt game file: Expected board \n" +
    	      "  (#{board}) \nis incorrect. Produced board \n  (#{@game_state.to_s})"
  	    end
      end

      game_file.close
    end
    
    def play
      for current_move in 0..@max_moves
        break if @game_rules.is_over?(@game_state)
        
        @messenger.puts @game_state.to_long_s
        
        next_move = ((@game_state.turn == 1) ? @player_pos : @player_neg).next_move(@game_state)
        unless next_move
          @messenger.puts ":::Quitting:::"
          return @game_state
        end
        
        unless @game_rules.is_legal?(@game_state, next_move)
          @messenger.puts ":::Illegal move " + next_move.to_s
          return @game_state
        else
          @messenger.puts "move" + current_move.to_s + "> " + next_move.to_s
        end

        @game_state = @game_state.apply_move(next_move)
      end

      if @game_rules.is_empty_side?(game_state)
        @messenger.puts @game_state.to_long_s
        @messenger.puts "move" + current_move.to_s + "> referee-empty sides"
        @game_state.empty_sides
      end
      
      @messenger.puts @game_state.to_long_s
      
      w = @game_rules.is_win?(@game_state)
      if w != 0
        @messenger.puts "Player \"" + (w > 0 ? "+" : "-") + "\" wins!"
      elsif @game_rules.is_tie?(@game_state)
        @messenger.puts "You tied."
      else
        @messenger.puts "Nobody wins after " + @max_moves.to_s + " moves."
      end
      
      return @game_state
	  end		
  end
end