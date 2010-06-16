module Kalah
  class InteractPlayer
    include Player
    
    def initialize(name, position, game_rules, messenger, input=nil)
      super(name, position, game_rules, messenger)
      @input = input || STDIN
    end
    
    def next_move(game_state)
      @messenger.print "(#{name}-#{position.to_s.upcase}) Enter next move (h for help, q to quit): "
      
      begin
        s = @input.gets
      rescue => err
        @messenger.puts "Error reading input."
      end
      
      s.downcase!
      return nil if s.starts_with? 'q'
      if s.starts_with? 'h'
        @messenger.puts "Enter a number [1-6] to sow from the given pit,\n"+
          "north's pits are on top and kalah's on the left,\n"+
          "south's pits are on bottom and kalah's on the right."
        return next_move(game_state)
      end
      
      begin
        move = s.to_i
      rescue => err
        @messenger.puts "Illegal move - try again"
        return next_move(game_state)
      end
      
      unless @game_rules.is_legal? game_state, move
        @messenger.puts "Illegal move - try again"
        return next_move(game_state)
      end
      
      move
    end
  end
end

# gr = Kalah::GameRules.new("alldiag")
# p = Kalah::InteractPlayer.new(gr)
# gs = Kalah::GameState.new
# gs = gs.applyMove(Kalah::Move.new(1,1))
# puts gs.to_long_s
# puts gr.legalMoves(gs)
# puts gr.isLegal(gs,Kalah::Move.new(2,2))
# puts p.get_next_move(gs)
