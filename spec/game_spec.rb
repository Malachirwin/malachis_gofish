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
    game.player_set_hand(3, [Card.new("H", 3)])
    player_request = Request.new('player3', 'player4', 4)
    expect(game.do_turn(player_request)).to eq "4 of Hearts"
    expect(player4.cards_left).to eq 5
    expect(player3.cards_left).to eq 2
  end

  it 'compares a card two a players hand and return true' do
    game.player_set_hand(1, [Card.new('H', 3), Card.new('D', 3), Card.new('H', 7), Card.new('H', 4), Card.new('S', 2)])
    game.player_set_hand(2, [Card.new('H', 3)])
    expect(game.card_in_player_hand(player1, 4, player2)).to eq '4 of Hearts'
    expect(player1.cards_left).to eq 4
    expect(player2.cards_left).to eq 2
  end

  it "compares a card two a players hand and return Go fish and player draws a card" do
    game.player_set_hand(2, [Card.new('H', 3), Card.new('H', 7), Card.new('H', 4), Card.new('H', 9), Card.new('D', 6)])
    game.player_set_hand(3, [Card.new("H", 10)])
    expect(game.card_in_player_hand(player2, "J", player3)).to eq "Go fish"
    expect(player2.cards_left).to eq 5
    expect(player3.cards_left).to eq 2
  end

  it "returns player if all players do not have any cards" do
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
    expect(game.winner).to eq "player2 had the most points with 2 points"
  end
end
