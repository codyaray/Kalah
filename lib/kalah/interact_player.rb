module Kalah
  class InteractPlayer
    include Player
    
    FMT_CMDLN = Kalah::Referee::FMT_CMDLN
    FMT_FILE  = Kalah::Referee::FMT_FILE
    
    def initialize(name, position, game_rules, messenger=STDOUT, input=STDIN, format=FMT_CMDLN)
      super(name, position, game_rules, messenger)

      @input  = input
      @format = format
    end
    
    def next_move(game_state)
      @messenger.print "(#{name}-#{position.to_s.upcase}) Enter next move (h for help, q to quit): " if @format == FMT_CMDLN
      
      begin
        s = @input.gets
      rescue => err
        @messenger.puts "Error reading input."
      end
      
      s.downcase!
      return nil if s.starts_with? 'q'
      if s.starts_with? 'h'
        @messenger.puts "  Enter a number [1-6] to sow from the given pit,\n"+
          "  north's pits are on top and kalah is on the left,\n"+
          "  south's pits are on bottom and kalah is on the right.\n"+
          "  Put '0' if there are no possible moves (all pits are empty)."
        return next_move(game_state)
      end
      
      begin
        move = Integer(s) # s.to_i doesn't throw exception on non-integer
      rescue => err
        @messenger.puts "Illegal move - try again"
        return next_move(game_state)
      end
      
      move = Move.new(position, move)
      unless @game_rules.is_legal? game_state, move
        @messenger.puts "Illegal move - try again"
        return next_move(game_state)
      end
      
      move
    end
  end
end