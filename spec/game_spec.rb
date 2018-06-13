require 'game'

describe 'GofishGame' do
  let(:game) { GofishGame.new }
  let(:player1)  { game.find_player(1) }
  let(:player2)  { game.find_player(2) }
  let(:player3)  { game.find_player(3) }
  let(:player4)  { game.find_player(4) }
  let(:player_turn) { game.player_turn}

  before do
    game.start(4)
  end

  it 'makes a game' do
    expect(game.num_of_games).to eq 1
  end

  it "sees if a player has a match of four cards" do
    player1.set_hand([Card.new('H', 3), Card.new('S', 3), Card.new('D', 3), Card.new('C', 3)])
    player2.set_hand([Card.new('H', 4), Card.new('S', 4), Card.new('D', 4), Card.new('C', 4)])
    game.pair
    expect(player1.cards_left).to eq 0
    expect(player2.cards_left).to eq 0
  end

  it "gives five cards to a player if they run out of cards" do
    game.player_set_hand(4, [Card.new('H', 3)])
    player_request = Request.new('player3', 'player4', 4)
    expect(game.do_turn(player_request)).to eq "player has a 4"
    expect(player4.cards_left).to eq 5
    expect(player3.cards_left).to eq 6
  end

  it 'compares a card two a players hand and return true' do
    game.player_set_hand(1, [Card.new('H', 3), Card.new('D', 3), Card.new('H', 7), Card.new('H', 4), Card.new('S', 2)])
    expect(game.card_in_player_hand(player1, 3, player2)).to eq 'player has a 3'
    expect(player1.cards_left).to eq 4
    expect(player2.cards_left).to eq 6
  end

  it "compares a card two a players hand and return Go fish and player draws a card" do
    game.player_set_hand(2, [Card.new('H', 3), Card.new('H', 7), Card.new('H', 4), Card.new('H', 9), Card.new('D', 6)])
    expect(game.card_in_player_hand(player2, "J", player3)).to eq "Go fish"
    expect(player2.cards_left).to eq 5
    expect(player3.cards_left).to eq 6
  end
  it "plays a full round" do
    game = GofishGame.new
    game.start(4)
    game.player_set_hand(1,[Card.new('H', 6), Card.new('H', 9), Card.new('H', 7), Card.new('H', 4), Card.new('H', 3)])
    game.player_set_hand(2,[Card.new('S', 6), Card.new('S', 9), Card.new('S', 7), Card.new('S', 4), Card.new('S', 3)])
    game.player_set_hand(3,[Card.new('D', 6), Card.new('D', 9), Card.new('D', 7), Card.new('D', 4), Card.new('D', 3)])
    game.player_set_hand(4,[Card.new('C', 6), Card.new('C', 9), Card.new('C', 7), Card.new('C', 4), Card.new('C', 3)])
    player_request = Request.new('player1', 'player3', "J")
    expect(game.do_turn(player_request)).to eq "Go fish"
    player_request = Request.new('player2', 'player1', 2)
    expect(game.do_turn(player_request)).to eq "Go fish"
    player_request = Request.new('player3', 'player2', 8)
    expect(game.do_turn(player_request)).to eq "player has a 8"
    player_request = Request.new('player3', 'player1', 11)
    expect(game.do_turn(player_request)).to eq "Go fish"
    player_request = Request.new('player4', 'player3', 13)
    expect(game.do_turn(player_request)).to eq "Go fish"
    player_request = Request.new('player1', 'player3', 11)
    expect(game.do_turn(player_request)).to eq "Go fish"
  end

  it "returns true if all players do not have any cards" do
    expect(game.winner).to eq false
    player2.set_hand([Card.new('H', 3), Card.new('S', 3), Card.new('D', 3), Card.new('C', 3)])
    game.pair
    player2.set_hand([Card.new('H', 6), Card.new('S', 6), Card.new('D', 6), Card.new('C', 6)])
    game.pair
    game.clear_deck
    game.player_set_hand(1, [])
    game.player_set_hand(2, [])
    game.player_set_hand(3, [])
    game.player_set_hand(4, [])
    expect(game.winner).to eq true
    expect(game.game_end).to eq "player2 had the most points with 2 points"
  end
end
