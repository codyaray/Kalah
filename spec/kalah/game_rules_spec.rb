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
    end
  end
end