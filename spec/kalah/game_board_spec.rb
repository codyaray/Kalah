require File.join(File.dirname(__FILE__), "/../spec_helper")

module Kalah
  describe GameBoard do
    context "the state representation" do
      it "should default to 6 6 6 6 6 6  6 6 6 6 6 6  0 0" do
        game_board = GameBoard.new
        game_board.to_s.should == "6 6 6 6 6 6  6 6 6 6 6 6  0 0"
      end
      
      it "should consist of north_pits, south_pits, north_kalah, and south_kalah" do
        north_pits = [ 3, 6, 3, 9, 2, 4]
        south_pits = [15, 2, 8, 7, 0, 1]
        north_kalah = [4]
        south_kalah = [8]
        game_board = GameBoard.new(north_pits, south_pits, north_kalah, south_kalah)
        game_board.to_s.should == "3 6 3 9 2 4  15 2 8 7 0 1  4 8"
      end
      
      it "should be available in a compact 14 element list of values" do
        game_board = GameBoard.new("1 2 3 4 5 6  5 4 3 2 1 0  4 7")
        game_board.to_s.should == "1 2 3 4 5 6  5 4 3 2 1 0  4 7"
      end
      
      it "should be available in a pretty ASCII graphic representation" do
        game_board = GameBoard.new("1 2 3 4 5 6  5 4 3 2 1 0  4 7")
        game_board.to_long_s.should == "    6  5  4  3  2  1\n 4                    7\n    5  4  3  2  1  0"
      end        
    end
    
    context "the hash" do
      it "should be different for every board" do
        game_boards = []
        game_boards << GameBoard.new("0 0 0 0 0 0  0 0 0 0 0 0  0 0")
        game_boards << GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_boards << GameBoard.new("7 6 6 6 6 6  6 6 6 6 6 6  0 0")
        game_boards << GameBoard.new("6 6 6 6 6 6  7 6 6 6 6 6  0 0")
        game_boards << GameBoard.new("6 6 6 6 6 7  6 6 6 6 6 6  0 0")
        game_boards << GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 7  0 0")
        game_boards << GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 6  1 0")
        game_boards << GameBoard.new("6 6 6 6 6 6  6 6 6 6 6 6  0 1")
        game_boards << GameBoard.new("1 2 3 4 5 6  5 4 3 2 1 0  4 7")

        hashes = []
        game_boards.each { |x| hashes << x.hash }
        hashes.uniq.should == hashes
      end
    end
    
    context "objects with the pits and kalahs of the same value" do
      it "should be equal" do
        game_board1 = GameBoard.new("1 2 3 4 5 6  5 4 3 2 1 0  4 7")
        game_board2 = GameBoard.new("1 2 3 4 5 6  5 4 3 2 1 0  4 7")
        game_board1.should == game_board2
      end
    end
  end
end