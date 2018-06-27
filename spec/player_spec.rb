require 'player'
require 'card'
require "json"

describe Player do
  it 'can be created with a list of cards' do
    cards = [Card.new("S", 1)]
    player = Player.new('name', cards)
    expect(player.cards_left).to be 1
  end

  it "turns a player to json" do
    player = Player.new("Malachi")
    player.set_hand([])
    expect(Player.new("Malachi").to_json).to eq "{\"name\":\"Malachi\",\"hand\":[],\"matches\":[]}"
  end

  it 'takes cards and puts them at the bottom of its hand' do
    player = Player.new('name')
    cards = [Card.new("S", 1), Card.new("D", 2)]
    player.take(cards)
    expect(player.cards_left).to eq 2
  end
end
