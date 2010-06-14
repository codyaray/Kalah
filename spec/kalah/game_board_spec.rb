require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe GameBoard do
    context "simple captures" do
      it "should sow north's first pit" do
        @game = GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:north,1)
        @game.to_s.should == "0 7 7 7 7 7  6 6 6 6 6 6  1 0"
      end

      it "should sow north's last pit" do
        @game = GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:north,6)
        @game.to_s.should == "6 6 6 6 6 0  7 7 7 7 7 6  1 0"
      end
      
      it "should sow south's first pit" do
        @game = GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:south,1)
        @game.to_s.should == "6 6 6 6 6 6  0 7 7 7 7 7  0 1"
      end

      it "should sow south's last pit" do
        @game = GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:south,6)
        @game.to_s.should == "7 7 7 7 7 6  6 6 6 6 6 0  0 1"
      end
      
      it "should sow north's first pit by wrapping around once" do
        @game = GameBoard.new("25 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:north,1)
        @game.to_s.should == "1 8 8 8 8 8  8 8 8 8 8 8  2 0"
      end

      it "should sow south's first pit by wrapping around once" do
        @game = GameBoard.new("6 6 6 6 6 6  25 6 6 6 6 6  0 0")
        @game.sow(:south,1)
        @game.to_s.should == "8 8 8 8 8 8  1 8 8 8 8 8  0 2"
      end

      it "should sow north's first pit by wrapping around twice" do
        @game = GameBoard.new("32 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:north,1)
        @game.to_s.should == "2 9 9 9 9 9  8 8 8 8 8 8  3 0"
      end

      it "should sow south's first pit by wrapping around twice" do
        @game = GameBoard.new("6 6 6 6 6 6  32 6 6 6 6 6  0 0")
        @game.sow(:south,1)
        @game.to_s.should == "8 8 8 8 8 8  2 9 9 9 9 9  0 3"
      end

      it "should sow north's first pit by wrapping around three times" do
        @game = GameBoard.new("45 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:north,1)
        @game.to_s.should == "3 10 10 10 10 10  9 9 9 9 9 9  4 0"
      end

      it "should sow south's first pit by wrapping around three times" do
        @game = GameBoard.new("6 6 6 6 6 6  45 6 6 6 6 6  0 0")
        @game.sow(:south,1)
        @game.to_s.should == "9 9 9 9 9 9  3 10 10 10 10 10  0 4"
      end
    end
    
    context "automatic go-again" do
      it "should sow north's pit in a go-again move when wrapping to non-empty pit" do
        @game = GameBoard.new("14 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:north,1)
        @game.to_s.should == "1 0 8 8 8 8  8 8 8 7 7 7  2 0"
      end

      it "should sow south's pit in a go-again move when wrapping to non-empty pit" do
        @game = GameBoard.new("6 6 6 6 6 6  14 6 6 6 6 6  0 0")
        @game.sow(:south,1)
        @game.to_s.should == "8 8 8 7 7 7  1 0 8 8 8 8  0 2"
      end

      it "should not sow north's pit in a go-again move when wrapping to empty or originating pit" do
        @game = GameBoard.new("13 6 6 6 6 6  6 6 6 6 6 6  0 0")
        @game.sow(:north,1)
        @game.to_s.should == "1 7 7 7 7 7  7 7 7 7 7 7  1 0"
      end

      it "should not sow south's pit in a go-again move when wrapping to empty or originating pit" do
        @game = GameBoard.new("6 6 6 6 6 6  13 6 6 6 6 6  0 0")
        @game.sow(:south,1)
        @game.to_s.should == "7 7 7 7 7 7  1 7 7 7 7 7  0 1"
    	end
    end
    
    context "cascading capture" do
      it "should sow north's pit in a cascade capture when previous pit has 2 or 3 stones" do
        @game = GameBoard.new("6 6 2 2 2 4  2 2 2 2 6 6  0 0")
        @game.sow(:north,6)
        @game.to_s.should == "6 6 2 2 2 0  0 0 0 2 6 6  10 0"
      end

      it "should sow south's pit in a cascade capture when previous pit has 2 or 3 stones" do
        @game = GameBoard.new("2 2 2 2 6 6  6 6 2 2 2 4  0 0")
        @game.sow(:south,6)
        @game.to_s.should == "0 0 0 2 6 6  6 6 2 2 2 0  0 10"
      end

      it "should sow north's pit in a cascade capture until the next preceeding pit doesn't have 2 or 3 stones" do
        @game = GameBoard.new("6 6 2 2 2 5  2 0 2 2 6 6  0 0")
        @game.sow(:north,6)
        @game.to_s.should == "6 6 2 2 2 0  3 1 0 0 6 6  7 0"
      end

      it "should sow south's pit in a cascade capture until the next preceeding pit doesn't have 2 or 3 stones" do
        @game = GameBoard.new("2 0 2 2 6 6  6 6 2 2 2 5  0 0")
        @game.sow(:south,6)
        @game.to_s.should == "3 1 0 0 6 6  6 6 2 2 2 0  0 7"
      end
    end    
  end
end