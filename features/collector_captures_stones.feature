Feature: capture the stones

  As a collector
  I want to capture over half the stones in my Kalah
  So that my Kalah has the majority of the stones
  And the game is over and provides a congratulatory message

  If a player who has the move has no stones available, the game ends
  immediately with all the opponent's stones going into the opponent's Kalah.
  Scenario: player has no moves available
    Given the board is 0 0 0 0 0 0  1 0 2 0 15 0  26 28
    When I play the game
    Then the game should be over
    And the board should be 0 0 0 0 0 0  0 0 0 0 0 0  26 46

  # Scenario: collect half the stones
  #   When I collect over half the stones
  #   Then the game should be over
  #   And  I should see the message "You captured the majority of the stones."
  #   
  # Scenario: end game
  #   Given the game is over
  #   And I should see the message "Play again? (y|n)"
  #   And I choose n
  #   Then I should not see the message "Welcome to Kalah!" again
  #   
  # Scenario: play again
  #   Given the board is 0 0 0 0 1 0  0 0 0 0 0 1  34 36
  #   When I select pit 6
  #   Then the game should be over
  #   And I should see the message "Play again? (y|n)"
  #   And I choose y
  #   Then the game should say "Welcome to Kalah!"
  #   And the game should say "Select pit for sowing:" 
  
 