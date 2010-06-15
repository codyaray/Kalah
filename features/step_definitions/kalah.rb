def messenger
  @messenger ||= StringIO.new
end

def referee
  @referee ||= Kalah::Referee.new('player+','player-','game_rules',100,messenger)
  @referee.fmt_file = false
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

Then /^the game should show previous game states$/ do
  # not sure how to implement this
end
