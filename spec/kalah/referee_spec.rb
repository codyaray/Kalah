require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe Referee do
    before(:each) do 
      @messenger = mock("messenger").as_null_object
      @referee = Referee.new(@messenger)
    end

    context "starting up" do      
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
      
    end
  end
end