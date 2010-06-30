require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe Referee do
    before(:each) do
      @messenger = mock("messenger").as_null_object
      game_rules = GameRules.new
      player_pos = RandomPlayer.new 'Me',  :north, game_rules, @messenger
      player_neg = RandomPlayer.new 'You', :south, game_rules, @messenger
      @referee   = Referee.new player_pos, player_neg, game_rules, 1000, Referee::FMT_FILE, @messenger
    end
    
    context "starting up" do
      it "should send a welcome message" do
        @referee.msg_format = Referee::FMT_CMDLN
        @messenger.should_receive(:puts).with("Welcome to Kalah!")
        @referee.start_game
      end
    end
    
    context "starting up from saved game" do      
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
    
    context "after winning" do
      it "should report the correct winner when the north player wins" do
        @referee.msg_format = Referee::FMT_CMDLN
        @messenger.should_receive(:puts).with("Player \"Me\" wins!")
        @referee.start_game("0 0 0 0 0 0  0 0 0 0 0 0  37 35")
        @referee.play
      end

      it "should report the correct winner when the south player wins" do
        @referee.msg_format = Referee::FMT_CMDLN
        @messenger.should_receive(:puts).with("Player \"You\" wins!")
        @referee.start_game("0 0 0 0 0 0  0 0 0 0 0 0  35 37")
        @referee.play
      end
    end
  end
end