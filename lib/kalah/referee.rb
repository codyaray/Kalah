module Kalah
  class Referee
    
    attr_accessor :game_state, :fmt_file
    
    def initialize(player_pos, player_neg, game_rules, max_moves, messenger=STDOUT)
      @player_pos = player_pos
      @player_neg = player_neg
      @game_rules = game_rules
      @max_moves = max_moves
      @messenger = messenger
      @fmt_file = true
    end

    def start_game(game_board="6 6 6 6 6 6  6 6 6 6 6 6  0 0")
      @game_state = Kalah::GameState.new(game_board)
      @messenger.puts "Welcome to Kalah!" unless @fmt_file
      @messenger.puts @game_state.to_s unless @fmt_file
      @messenger.puts "Select pit for sowing:" unless @fmt_file
      @player1turn = true
    end
    
    def start_game_from_file(game_id)
      file = File.join(File.dirname(__FILE__), "..","..","games",game_id+".kalah")
      File.open(file, "r") do |game_file|
        begin
          player1name = game_file.gets.strip
          player2name = game_file.gets.strip
          player1pos  = game_file.gets.strip
          player2pos  = game_file.gets.strip

          @messenger.puts player1name, player2name, player1pos, player2pos if @fmt_file
          
          player1pos = player1pos.downcase.to_sym
          player2pos = player2pos.downcase.to_sym

          # @player1 = Kalah::InteractPlayer.new(player1name, player1pos.downcase.to_sym, STDIN, STDOUT)
          # @player2 = Kalah::InteractPlayer.new(player2name, player2pos.downcase.to_sym, STDIN, STDOUT)

          start_game(b = game_file.gets.strip)
          @messenger.puts b if @fmt_file
          while (pit = game_file.gets and b = game_file.gets.strip)
            pit = pit.strip.to_i

            begin
              move = @player1turn ? Move.new(player1pos,pit) : Move.new(player2pos,pit)
          	  @game_state = @game_state.apply_move(move)

          	  @messenger.puts pit, @game_state.to_s if @fmt_file
            rescue => err
              raise Kalah::SavedGameError, "Corrupt game file: #{err.message}"
            end
            
        	  if @game_state.to_s != b
        	    raise Kalah::SavedGameError, "Corrupt game file: Expected board \n" +
        	      "  (#{b}) \nis incorrect. Produced board \n  (#{@game_state.to_s})"
      	    end
      	    
      	    change_turn
          end
        rescue Kalah::SavedGameError => err
          raise err
        rescue => err
          raise Kalah::SavedGameError, "Corrupt game file: #{file}\n#{err}"
        end
      end
    end
    
    def play
      for current_move in 0..@max_moves
        break if @game_rules.is_win?(@game_state) != 0
        
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
      
      @messenger.puts @game_state.to_long_s
      
      w = @game_rules.is_win(@game_state)
      if w != 0
        @messenger.puts "Player \"" + (w > 0 ? "+" : "-") + "\" wins!"
      else
        @messenger.puts "Nobody wins after " + @max_moves.to_s + " moves."
      end
      
      return @game_state
	  end
		
    private
      def change_turn
        @player1turn = !@player1turn
        @current_player = @player1turn ? @player1 : @player2
		  end
  end
end