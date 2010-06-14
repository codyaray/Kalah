module Kalah
  class Referee
    
    attr_accessor :board, :turn
    
    def initialize(messenger=STDOUT)
      @messenger = messenger
    end

    def start_game(board="6 6 6 6 6 6  6 6 6 6 6 6  0 0")
      @board = Kalah::GameBoard.new(board)
      @messenger.puts "Welcome to Kalah!"
      @messenger.puts @board.to_s
      @messenger.puts "Select pit for sowing:"
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
          	  board.sow(player1pos,pit) if  @player1turn
              board.sow(player2pos,pit) unless @player1turn
            rescue => err
              raise Kalah::SavedGameError, "Corrupt game file: #{err.message}"
            end
            
        	  if board.to_s != b
        	    raise Kalah::SavedGameError, "Corrupt game file: Expected board \n  (#{b}) \nis incorrect. Produced board \n  (#{board})"
      	    end
      	    
      	    change_turn
          end
        rescue Kalah::SavedGameError => err
          raise err
        rescue => err
          raise Kalah::SavedGameError, "Corrupt game file: #{filename}\n#{err}"
        end
      end
    end
    
    def play
	  end
		
    private
      def change_turn
        @player1turn = !@player1turn
        @current_player = @player1turn ? @player1 : @player2
		  end
  end
end