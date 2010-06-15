module Kalah
  class Move
    
    attr_accessor :position, :pit
    
    def initialize(position, pit)
      @position = position
      @pit = pit
    end
        
  end
end