require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe InteractPlayer do
    context "getting the next move" do
      before(:each) do
        @messenger  = mock("messenger").as_null_object
        @pit        = (1+rand(6)).to_s
        @input      = StringIO.new @pit,'r'
        @game_rules = GameRules.new
        @myplayer   = InteractPlayer.new 'Interact Player',:south,@game_rules,@messenger,@input
        @player     = RandomPlayer.new 'Random Player',:north,@game_rules,@messenger
        @referee    = Referee.new @myplayer, @player, @game_rules, @max_moves, @messenger
        @game_state = GameState.new
      end
      
      it "should return a move for the correct position" do
        next_move = @myplayer.next_move(@game_state)
        next_move.position.should == :south
      end
      
      it "should return a move for the correct pit" do
        next_move = @myplayer.next_move(@game_state)
        next_move.pit.should == @pit.to_i
      end
    end
  end
end