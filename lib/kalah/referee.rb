module Kalah
  class Referee
    
    FMT_FILE    = :file
    FMT_CMDLN   = :cmdln
    
    attr_accessor :game_state, :player_pos, :player_neg, :msg_format
    
    def initialize(player_pos, player_neg, game_rules, max_moves, msg_format=FMT_CMDLN, messenger=STDOUT)
      @player_pos = player_pos
      @player_neg = player_neg
      @game_rules = game_rules
      @max_moves  = max_moves
      @msg_format = msg_format
      @messenger  = messenger
      
      @game_rules.referee = self

      trap("INT") { @messenger.puts ":::Quitting:::"; exit }
    end    

    def start_game(game_board="6 6 6 6 6 6  6 6 6 6 6 6  0 0")
      @game_state = Kalah::GameState.new(game_board)
      @messenger.puts "Welcome to Kalah!" if @msg_format == FMT_CMDLN
      @shown_first_board = false
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
        @player_pos.position.to_s.upcase, @player_neg.position.to_s.upcase if @msg_format == FMT_FILE
      
      start_game(board = game_file.gets.strip)
      show_board
      while (pit = game_file.gets and board = game_file.gets.strip)
        pit = pit.strip.to_i

        begin
          next_move = ((@game_state.turn == 1) ? Move.new(@player_pos.position,pit) : Move.new(@player_neg.position,pit))
      	  @game_state = @game_state.apply_move(next_move)
      	  @messenger.puts "saved-move> " + next_move.to_s if @msg_format == FMT_CMDLN          
      	  @messenger.puts pit if @msg_format == FMT_FILE
      	  show_board
        rescue => err
          raise Kalah::SavedGameError, "Corrupt game file: #{err.inspect}"
        end
      
    	  if @game_state.to_s != board
    	    raise Kalah::SavedGameError, "Corrupt game file: Expected board \n" +
    	      "  (#{board}) \nis incorrect. Produced board \n  (#{@game_state.to_s})"
  	    end
      end
      
      @shown_first_board = true
      game_file.close
    end
    
    def play
      show_board unless @shown_first_board
      
      for current_move in 0..@max_moves
        break if @game_rules.is_over?(@game_state)
                
        next_move = ((@game_state.turn == 1) ? @player_pos : @player_neg).next_move(@game_state)
        unless next_move
          @messenger.puts ":::Quitting:::"
          return @game_state
        end        
        
        unless @game_rules.is_legal?(@game_state, next_move)
          @messenger.puts ":::Illegal move " + next_move.to_s
          return @game_state
        else
          @messenger.puts "move" + current_move.to_s + "> " + next_move.to_s if @msg_format == FMT_CMDLN
          @messenger.puts next_move.pit if @msg_format == FMT_FILE
        end

        @game_state = @game_state.apply_move(next_move)
        
        show_board
      end
            
      w = @game_rules.is_win?(@game_state)
      if w != 0
        @messenger.puts "Player \"" + (w > 0 ? "+" : "-") + "\" wins!" if @msg_format == FMT_CMDLN
      elsif @game_rules.is_tie?(@game_state)
        @messenger.puts "You tied." if @msg_format == FMT_CMDLN
      else
        @messenger.puts "Nobody wins after " + @max_moves.to_s + " moves." if @msg_format == FMT_CMDLN
      end
      
      return @game_state
	  end
	  
	  def show_board
	    @messenger.puts @game_state.to_s if @msg_format == FMT_FILE
      @messenger.puts @game_state.to_long_s if @msg_format == FMT_CMDLN
    end
  end
end