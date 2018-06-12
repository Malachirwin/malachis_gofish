require 'game'

describe 'GofishGame' do
  it 'makes a game three games' do
    game = GofishGame.new
    game1 = game.start
    game2 = game.start
    game3 = game.start
    expect(game.num_of_games).to eq 3
  end

  it 'compares a card two a players hand and return true' do
    game = GofishGame.new
    game.start
    player2 = game.find_player(2)
    player1 = game.find_player(1)
    game.player_set_hand(1, [Card.new('H', 3), Card.new('D', 3), Card.new('H', 7), Card.new('H', 4), Card.new('S', 2)])
    expect(game.card_in_player_hand(player1, 3, player2)).to eq 'player has a 3'
    expect(player1.cards_left).to eq 4
    expect(player2.cards_left).to eq 6
  end

  it "compares a card two a players hand and return Go fish and player draws a card" do
    game = GofishGame.new
    game.start
    player2 = game.find_player(2)
    player3 = game.find_player(3)
    game.player_set_hand(2, [Card.new('H', 3), Card.new('H', 7), Card.new('H', 4), Card.new('H', 9), Card.new('D', 6)])
    expect(game.card_in_player_hand(player2, 10, player3)).to eq "Go fish"
    expect(player2.cards_left).to eq 5
    expect(player3.cards_left).to eq 6
  end

  it 'compares a card to player 4 and return something different when only one' do
    game = GofishGame.new
    game.start
    player1 = game.find_player(1)
    player4 = game.find_player(4)
    game.player_set_hand(4, [Card.new('H', 3), Card.new('H', 7), Card.new('H', 4), Card.new('S', 8), Card.new('S', 10)])
    expect(game.card_in_player_hand(player4, 7, player1)).to eq "player has a 7"
    expect(player1.cards_left).to eq 6
    expect(player4.cards_left).to eq 4
  end
end
