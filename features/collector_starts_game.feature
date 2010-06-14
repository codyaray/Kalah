Feature: collector starts game

  As a collector
  I want to start a game
  So that I can capture the stones

  Scenario: start game
    Given I am not yet playing
    When I start a new game
    Then the game should say "Welcome to Kalah!"
    And the game should say "Select pit for sowing:"

  Scenario: start saved game
    Given a saved game "example_game"
    When I restart the saved game
    Then the game should show previous game states

  # Scenario: start game in testing mode
  #   Given a saved game for testing
  #   When I restart the saved game
  #   Then the game should show previous states
  #   And the game should read the pit selection from stdin
  #   And the game should show the selected pit
  #   And the game should show the board
  #   And the game should exit