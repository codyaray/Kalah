Feature: collector sows stones

  As a collector
  I want to sew the stones from my pits around
  So that I can capture over half the stones in my Kalah

  Play begins with one player removing all stones from one of the player's 
  small pits, and sowing them into other pits in counterclockwise fashion 
  around the board. Sowing begins in the pit to the right of the source pit 
  and includes the player's own Kalah and the opponent's small pits, but not 
  the opponent's Kalah.

  Scenario Outline: sow stones
    Given the board is <board>
    When the <position> collector sows stones from pit <pit>
    Then the board should be <result>

  Scenarios: one capture - no wrap around
    | board                          | position | pit  | result                        |
    |  6 6 6 6 6 6  6 6 6 6 6 6  0 0 | north    | 1    | 0 7 7 7 7 7  6 6 6 6 6 6  1 0 |
    |  6 6 6 6 6 6  6 6 6 6 6 6  0 0 | north    | 6    | 6 6 6 6 6 0  7 7 7 7 7 6  1 0 |
    |  6 6 6 6 6 6  6 6 6 6 6 6  0 0 | south    | 1    | 6 6 6 6 6 6  0 7 7 7 7 7  0 1 |
    |  6 6 6 6 6 6  6 6 6 6 6 6  0 0 | south    | 6    | 7 7 7 7 7 6  6 6 6 6 6 0  0 1 |

  Scenarios: one capture - one wrap around
    | board                          | position | pit  | result                        |
    | 25 6 6 6 6 6  6 6 6 6 6 6  0 0 | north    | 1    | 1 8 8 8 8 8  8 8 8 8 8 8  2 0 |
    | 6 6 6 6 6 6  25 6 6 6 6 6  0 0 | south    | 1    | 8 8 8 8 8 8  1 8 8 8 8 8  0 2 |

  Scenarios: one capture - multiple wrap around
    | board                          | position | pit  | result                        |
    | 32 6 6 6 6 6  6 6 6 6 6 6  0 0 | north    | 1    | 2 9 9 9 9 9  8 8 8 8 8 8  3 0 |
    | 6 6 6 6 6 6  32 6 6 6 6 6  0 0 | south    | 1    | 8 8 8 8 8 8  2 9 9 9 9 9  0 3 |
    | 45 6 6 6 6 6  6 6 6 6 6 6  0 0 | north    | 1    | 3 10 10 10 10 10  9 9 9 9 9 9  4 0 |
    | 6 6 6 6 6 6  45 6 6 6 6 6  0 0 | south    | 1    | 9 9 9 9 9 9  3 10 10 10 10 10  0 4 |

  Scenarios: no automatic go-again - wrap to empty or originating pit
    | board                          | position | pit  | result                        |
	| 13 6 6 6 6 6  6 6 6 6 6 6  0 0 | north    | 1    | 1 7 7 7 7 7  7 7 7 7 7 7  1 0 |
	| 6 6 6 6 6 6  13 6 6 6 6 6  0 0 | south    | 1    | 7 7 7 7 7 7  1 7 7 7 7 7  0 1 |

  Scenarios: automatic go-again - wrap to non-empty pit
    | board                          | position | pit  | result                        |
    | 14 6 6 6 6 6  6 6 6 6 6 6  0 0 | north    | 1    | 1 0 8 8 8 8  8 8 8 7 7 7  2 0 |
    | 6 6 6 6 6 6  14 6 6 6 6 6  0 0 | south    | 1    | 8 8 8 7 7 7  1 0 8 8 8 8  0 2 |

  Scenarios: cascading capture - wrap to pit with 2 or 3 stones - previous have 2 or 3 stones
    | board                          | position | pit  | result                        |
    |  6 6 2 2 2 4  2 2 2 2 6 6  0 0 | north    | 6    | 6 6 2 2 2 0  0 0 0 2 6 6  10 0 |
    |  2 2 2 2 6 6  6 6 2 2 2 4  0 0 | south    | 6    | 0 0 0 2 6 6  6 6 2 2 2 0  0 10 |

  Scenarios: cascading capture with stop - wrap to pit with 2 or 3 stones - previous don't have 2 or 3 stones
    | board                          | position | pit  | result                        |
    |  6 6 2 2 2 5  2 0 2 2 6 6  0 0 | north    | 6    | 6 6 2 2 2 0  3 1 0 0 6 6  7 0 |
    |  2 0 2 2 6 6  6 6 2 2 2 5  0 0 | south    | 6    | 3 1 0 0 6 6  6 6 2 2 2 0  0 7 |
