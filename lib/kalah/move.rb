module Kalah
  class Move
    
    attr_accessor :position, :pit
    
    def initialize(position, pit)
      @position = position
      @pit = pit
    end
    
    def ==(other)
      other.position == position and other.pit == pit
    end
    
    def to_s
      position.to_s + "-" + pit.to_s
    end
        
  end
end