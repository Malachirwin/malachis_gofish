require 'rspec'
require 'card_deck'
require 'pry'

describe "CardDeck" do
  it 'should have 52 cards when created' do
    deck = CardDeck.new
    expect(deck.cards_left).to eq 52
  end

  it 'should deal cards to players' do
    deck = CardDeck.new
    player1 = Player.new("player1")
    player2 = Player.new("player2")
    deck.deal(deck, player1, player2)
    expect(player1.cards_left).to eq 5
    expect(player2.cards_left).to eq 5
  end

  it 'returns true if deck has cards' do
    deck = CardDeck.new
    expect(deck.has_cards?).to eq true
  end
end
