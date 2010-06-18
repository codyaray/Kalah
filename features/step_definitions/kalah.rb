def messenger
  @messenger ||= StringIO.new
end

def referee
  unless @referee
    @game_rules = Kalah::GameRules.new
    player_pos = Kalah::RandomPlayer.new 'Me',  :north, @game_rules, messenger
    player_neg = Kalah::RandomPlayer.new 'You', :south, @game_rules, messenger
    @referee = Kalah::Referee.new player_pos, player_neg, @game_rules, 1000,
      Kalah::Referee::FMT_CMDLN, messenger
  end

  @referee
end

def messages_should_include(message)
  messenger.string.split("\n").should include(message)
end

Given /^I am not yet playing$/ do
end

When /^I start a new game$/ do
  referee.start_game
end

Then /^the game should say "(.*)"$/ do |message|
  messages_should_include(message)
end

Given /^the board is (.*)$/ do |board|
  referee.start_game(board)
end

When /^the (.*) collector sows stones from pit (.*)$/ do |position, pit|
  referee.game_state = referee.game_state.apply_move(Kalah::Move.new(position.to_sym,pit.to_i))
end

Then /^the board should be (.*)$/ do |board|
  referee.game_state.to_s.should == board
end

Given /^a saved game "([^\"]*)"$/ do |game_id|
  @game_id = game_id
end

When /^I restart the saved game$/ do
  referee.start_game_from_file(@game_id)
end

When /^I play the game$/ do
  referee.play
end

Then /^the game should be over$/ do
  @game_rules.is_over?(referee.game_state)
end
