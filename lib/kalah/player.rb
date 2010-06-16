module Kalah
  module Player
    attr_accessor :name, :position
    
    def initialize(name, position, game_rules, messenger=STDOUT)
      @name = name
      @position = position
      @game_rules = game_rules
      @messenger = messenger
    end
    
    def to_s
      @name + " " + @position.to_s.upcase
    end
  end
end