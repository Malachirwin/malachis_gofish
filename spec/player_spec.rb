require 'player'
require 'card'

describe Player do
  it 'can be created with a list of cards' do
    cards = [Card.new("S", 1)]
    player = Player.new('name', cards)
    expect(player.cards_left).to be 1
  end

  it 'takes cards and puts them at the bottom of its hand' do
    player = Player.new('name')
    cards = [Card.new("S", 1), Card.new("D", 2)]
    player.take(cards)
    expect(player.cards_left).to eq 2
  end
end
