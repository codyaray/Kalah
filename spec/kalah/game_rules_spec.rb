require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe GameRules do
    context "to win" do
      before(:each) do
        @game_rules = GameRules.new
      end
      
      it "should occur when north kalah has captured over half the stones" do
        game_state = GameState.new("0 0 0 0 0 0  0 0 1 0 0 0  37 34")
        @game_rules.is_win?(game_state).should == +1
      end
      
      it "should occur when south kalah has captured over half the stones" do
        game_state = GameState.new("0 0 1 0 0 0  0 0 0 0 0 0  34 37")
        @game_rules.is_win?(game_state).should == -1
      end
      
      it "should not occur when less than half the stones have been captured in the north kalah" do
        game_state = GameState.new("0 0 1 1 0 0  0 2 0 1 0 0  32 35")
        @game_rules.is_win?(game_state).should == 0
      end
      
      it "should not occur when less than half the stones have been captured in the south kalah" do
        game_state = GameState.new("0 2 0 1 0 0  0 0 1 1 0 0  35 32")
        @game_rules.is_win?(game_state).should == 0
      end
      
      it "should not occur when exactly half the stones have been capture in each kalah" do
        game_state = GameState.new("0 0 0 0 0 0  0 0 0 0 0 0  36 36")
        @game_rules.is_win?(game_state).should == 0
      end
      
      it "should tie when each player has captured exactly one half the stones in their kalahs" do
        game_state = GameState.new("0 0 0 0 0 0  0 0 0 0 0 0  36 36")
        @game_rules.is_tie?(game_state).should == true
      end
    end
    
    context "legal moves" do
      before(:each) do
        @messenger  = mock("messenger").as_null_object
        @pit        = (1+rand(6)).to_s
        @input      = StringIO.new @pit,'r'
        @position   = :south
        @game_rules = GameRules.new
        @myplayer   = InteractPlayer.new 'Interact Player',@position,@game_rules,@messenger,@input
        @player     = RandomPlayer.new 'Random Player',[:north,:south]-[@position],@game_rules,@messenger
        @referee    = Referee.new @myplayer, @player, @game_rules, @max_moves, @messenger
        @game_state = GameState.new
      end
      
      it "should include moves from the players pits" do
        move_list = @game_rules.legal_moves(@game_state)
        move_list.each do |m|
          m.position.should == :south
        end
      end
      
      it "should not include moves from the opponents pits" do
        move_list = @game_rules.legal_moves(@game_state)
        move_list.each do |m|
          m.position.should_not == :north
        end
      end
      
      it "should not include empty pits" do
        @game_state = GameState.new("6 6 6 6 6 6  0 7 7 7 7 7  0 1")
        pits = @game_state.game_board.south_pits # @position = :south
        move_list = @game_rules.legal_moves(@game_state)
        move_list.each do |m|
          pits[m.pit-1].should_not == 0
        end
      end
    end
  end
end