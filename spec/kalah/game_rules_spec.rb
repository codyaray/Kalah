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
    end
  end
end