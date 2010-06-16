require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe Referee do
    before(:each) do
      @messenger = mock("messenger").as_null_object
      game_rules = Kalah::GameRules.new
      player_pos = Kalah::RandomPlayer.new 'Me',  :north, game_rules, @messenger
      player_neg = Kalah::RandomPlayer.new 'You', :south, game_rules, @messenger
      @referee = Kalah::Referee.new player_pos, player_neg, game_rules, 1000, @messenger
    end

    context "starting up" do      
      before(:each) do 
        @referee.fmt_file = false
      end

      it "should send a welcome message" do
        @messenger.should_receive(:puts).with("Welcome to Kalah!")
        @referee.start_game
      end
      
      it "should show the initial board state with default board" do
        @messenger.should_receive(:puts).with("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @referee.start_game
      end

      it "should show the initial board state with given board" do
        state = "0 7 7 7 7 7  6 6 6 6 6 6  1 0"
        @messenger.should_receive(:puts).with(state)
        @referee.start_game(state)
      end
      
      it "should prompt for the first pit for sowing" do
        @messenger.should_receive(:puts).with("Select pit for sowing:")
        @referee.start_game
      end
    end
    
    context "starting up from saved game" do
      before(:each) do 
        @referee.fmt_file = true
      end
      
      it "should result in the last state" do
        @referee.start_game_from_file "test_game_correct"
        @referee.game_state.to_s.should == "8 8 8 6 6 0  7 7 0 2 9 8  1 2"
      end
      
      it "should raise an error when the file corresponding to the given game_id does not exist" do
        lambda { @referee.start_game_from_file "test_game_does_not_exist" }.should raise_error(Kalah::SavedGameError)
      end
      
      it "should raise an error when we calculate a board different from what's expected in the saved game" do
        lambda { @referee.start_game_from_file "test_game_incorrect_expected_board" }.should raise_error(Kalah::SavedGameError)
      end
      
      it "should raise an error when pit selection is not in [1,6]" do
        lambda { @referee.start_game_from_file("test_game_invalid_pit") }.should raise_error
      end
    end
  end
end