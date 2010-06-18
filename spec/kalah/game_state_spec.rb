require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe GameState do
    context "board" do
      it "should default to 6 6 6 6 6 6  6 6 6 6 6 6  0 0" do
        game_state = GameState.new
        game_state.to_s.should == "6 6 6 6 6 6  6 6 6 6 6 6  0 0"
      end
    end
    
    context "simple captures" do
      it "should apply_move north's first pit" do
        game_state = GameState.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,1))
        game_state.to_s.should == "0 7 7 7 7 7  6 6 6 6 6 6  1 0"
      end

      it "should apply_move north's last pit" do
        game_state = GameState.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,6))
        game_state.to_s.should == "6 6 6 6 6 0  7 7 7 7 7 6  1 0"
      end
      
      it "should apply_move south's first pit" do
        game_state = GameState.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,1))
        game_state.to_s.should == "6 6 6 6 6 6  0 7 7 7 7 7  0 1"
      end

      it "should apply_move south's last pit" do
        game_state = GameState.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,6))
        game_state.to_s.should == "7 7 7 7 7 6  6 6 6 6 6 0  0 1"
      end
      
      it "should apply_move north's first pit by wrapping around once" do
        game_state = GameState.new("25 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,1))
        game_state.to_s.should == "1 8 8 8 8 8  8 8 8 8 8 8  2 0"
      end

      it "should apply_move south's first pit by wrapping around once" do
        game_state = GameState.new("6 6 6 6 6 6  25 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,1))
        game_state.to_s.should == "8 8 8 8 8 8  1 8 8 8 8 8  0 2"
      end

      it "should apply_move north's first pit by wrapping around twice" do
        game_state = GameState.new("32 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,1))
        game_state.to_s.should == "2 9 9 9 9 9  8 8 8 8 8 8  3 0"
      end

      it "should apply_move south's first pit by wrapping around twice" do
        game_state = GameState.new("6 6 6 6 6 6  32 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,1))
        game_state.to_s.should == "8 8 8 8 8 8  2 9 9 9 9 9  0 3"
      end

      it "should apply_move north's first pit by wrapping around three times" do
        game_state = GameState.new("45 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,1))
        game_state.to_s.should == "3 10 10 10 10 10  9 9 9 9 9 9  4 0"
      end

      it "should apply_move south's first pit by wrapping around three times" do
        game_state = GameState.new("6 6 6 6 6 6  45 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,1))
        game_state.to_s.should == "9 9 9 9 9 9  3 10 10 10 10 10  0 4"
      end
    end
    
    context "automatic go-again" do
      it "should apply_move north's pit in a go-again move when wrapping to non-empty pit" do
        game_state = GameState.new("14 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,1))
        game_state.to_s.should == "1 0 8 8 8 8  8 8 8 7 7 7  2 0"
      end

      it "should apply_move south's pit in a go-again move when wrapping to non-empty pit" do
        game_state = GameState.new("6 6 6 6 6 6  14 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,1))
        game_state.to_s.should == "8 8 8 7 7 7  1 0 8 8 8 8  0 2"
      end

      it "should not apply_move north's pit in a go-again move when wrapping to empty or originating pit" do
        game_state = GameState.new("13 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,1))
        game_state.to_s.should == "1 7 7 7 7 7  7 7 7 7 7 7  1 0"
      end

      it "should not apply_move south's pit in a go-again move when wrapping to empty or originating pit" do
        game_state = GameState.new("6 6 6 6 6 6  13 6 6 6 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,1))
        game_state.to_s.should == "7 7 7 7 7 7  1 7 7 7 7 7  0 1"
    	end
    	
    	it "should not go-again a second time without wrapping around again first" do
        game_state = GameState.new("6 2 6 6 2 9  3 8 5 6 9 7  1 2")
        game_state = game_state.apply_move(Kalah::Move.new(:north,6))
        game_state.to_s.should     == "7 0 7 7 3 0  4 9 6 7 10 8  2 2"
        game_state.to_s.should_not == "7 0 7 7 0 1  5 9 6 7 10 8  3 2"
      end
    end
    
    context "cascading capture" do
      it "should apply_move north's pit in a cascade capture when previous pit has 2 or 3 stones" do
        game_state = GameState.new("6 6 2 2 2 4  2 2 2 2 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,6))
        game_state.to_s.should == "6 6 2 2 2 0  0 0 0 2 6 6  10 0"
      end

      it "should apply_move south's pit in a cascade capture when previous pit has 2 or 3 stones" do
        game_state = GameState.new("2 2 2 2 6 6  6 6 2 2 2 4  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,6))
        game_state.to_s.should == "0 0 0 2 6 6  6 6 2 2 2 0  0 10"
      end

      it "should apply_move north's pit in a cascade capture until the next preceeding pit doesn't have 2 or 3 stones" do
        game_state = GameState.new("6 6 2 2 2 5  2 0 2 2 6 6  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:north,6))
        game_state.to_s.should == "6 6 2 2 2 0  3 1 0 0 6 6  7 0"
      end

      it "should apply_move south's pit in a cascade capture until the next preceeding pit doesn't have 2 or 3 stones" do
        game_state = GameState.new("2 0 2 2 6 6  6 6 2 2 2 5  0 0")
        game_state = game_state.apply_move(Kalah::Move.new(:south,6))
        game_state.to_s.should == "3 1 0 0 6 6  6 6 2 2 2 0  0 7"
      end
    end
    
    it "should move opponent's stones into opponent's Kalah if no stones available" do
      game_state = GameState.new("0 0 0 0 0 0  1 0 2 0 15 0  26 28")
      game_state.empty_sides
      game_state.to_s.should == "0 0 0 0 0 0  0 0 0 0 0 0  26 46"
    end    
  end
end