require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe RandomPlayer do
    context "getting the next move" do
      before(:each) do
        @messenger  = mock("messenger").as_null_object
        @game_rules = GameRules.new
        @myplayer   = RandomPlayer.new 'Random Player',:south,@game_rules,@messenger
        @player     = InteractPlayer.new 'Interact Player',:north,@game_rules,@messenger,@input
        @referee    = Referee.new @myplayer, @player, @game_rules, @max_moves, @messenger
      end
      
      it "should return a move for the correct position" do
        game_state = GameState.new
        next_move = @myplayer.next_move(game_state)
        next_move.position.should == :south
      end
      
      it "should not return an empty pit" do
        south_pits = []
        pit = (1+rand(6))
        (1..6).each do |i|
          if i == pit
            south_pits << 0
          else
            south_pits << 6
          end
        end
        
        game_state = GameState.new("6 6 6 6 6 6   " + south_pits.join(" ") + "  0 6")
        next_move = @myplayer.next_move(game_state)
        next_move.pit.should_not == pit
      end
    end
  end
end