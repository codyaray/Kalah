module Kalah
  class Referee
    
    FMT_FILE    = :file  # file format
    FMT_CMDLN   = :cmdln # command-line interface
    FMT_PERF    = :perf  # performance info: num states eval'd, time used, depth achieved
    FMT_QUIET   = :quiet # output as little as possible
    FMT_VBOSE   = :vbose # verbose output
    
    GAME_PATH   = File.join(File.dirname(__FILE__), "..", "..", "games")
    
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
      if File.exist? File.expand_path(game_id)
         # given a path to an existing file
         # (can be relative or include "~")
        file = File.expand_path game_id
      else
        # default game path + extension
        file = File.join(GAME_PATH, game_id+".kalah")
      end
      
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
          next_move = Move.new(current_player.position,pit)
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

    def current_player
      player(@game_state.turn)
    end
    
    def player(turn)
      (turn == 1) ? @player_pos : @player_neg
    end
    
    def play
      show_board unless @shown_first_board
      @messenger.puts "%-40s %-15s %-10s %-10s" % 
        ["Current Board","States Eval'd","Time Used","Depth Achieved"] if @msg_format == FMT_PERF
      
      elapsed_time = "%.5s" % Benchmark.realtime do
        for current_move in 1..@max_moves
          break if @game_rules.is_over?(@game_state)
        
          next_move = nil
          elapsed_time = "%.5s" % Benchmark.realtime do
            next_move = current_player.next_move(@game_state)
          end
          
          states_evaluated = "", states_evaluated_s = ""
          if current_player.respond_to? :num_states_evaluated
            states_evaluated = "%.5s" % current_player.num_states_evaluated
            states_evaluated_s = "#{states_evaluated} states evaluated in "
          end

          depth_achieved = ""
          if current_player.respond_to? :depth_achieved
            depth_achieved = "%.4s" % current_player.depth_achieved
          end

          unless next_move
            @messenger.puts ":::Quitting:::"
            return @game_state
          end        
        
          unless @game_rules.is_legal?(@game_state, next_move)
            @messenger.puts ":::Illegal move " + next_move.to_s
            return @game_state
          else
            @messenger.puts "move" + current_move.to_s + "> " + next_move.to_s +
              " (#{states_evaluated_s}#{elapsed_time}s)" if @msg_format == FMT_CMDLN
            @messenger.puts next_move.pit if @msg_format == FMT_FILE
            @messenger.puts "%-40s %-15s %-10s %-10s" % 
              [game_state,states_evaluated, elapsed_time, depth_achieved] if @msg_format == FMT_PERF
          end

          @game_state = @game_state.apply_move(next_move)
        
          show_board
        end
      end

      if @msg_format == FMT_CMDLN
        w = @game_rules.is_win?(@game_state)
        if w != 0
          @messenger.puts "Player \"" + (w > 0 ? player_pos.name : player_neg.name) + "\" wins!"
        elsif @game_rules.is_tie?(@game_state)
          @messenger.puts "You tied."
        else
          @messenger.puts "Nobody wins after " + @max_moves.to_s + " moves."
        end
      end
    
      if @msg_format == FMT_QUIET or @msg_format == FMT_PERF
        @messenger.puts @game_state
      end

      @messenger.puts "Total time spent playing was #{elapsed_time}s" if @msg_format == FMT_CMDLN

      return @game_state
	  end
	  
	  def show_board
	    @messenger.puts @game_state.to_s if @msg_format == FMT_FILE
      @messenger.puts @game_state.to_long_s if @msg_format == FMT_CMDLN
    end
  end
end