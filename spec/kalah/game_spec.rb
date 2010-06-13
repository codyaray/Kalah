require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe Game do
    context "starting up" do
      before(:each) do 
        @messenger = mock("messenger").as_null_object
        @game = Game.new(@messenger)
      end
      
      it "should send a welcome message" do
        @messenger.should_receive(:puts).with("Welcome to Kalah!")
        @game.start
      end
      
      it "should prompt for the first guess" do
        @messenger.should_receive(:puts).with("Select pit for sowing:")
        @game.start
      end
    end
  end
end