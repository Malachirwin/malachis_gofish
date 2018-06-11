require 'rspec'
require 'card'

describe 'Card' do
  it 'ruturns the suit' do
    card = Card.new('H', 1)
    expect(card.suit).to eq 'H'
  end
  it 'ruturns the rank' do
    card = Card.new('H', 1)
    expect(card.rank).to eq 1
  end
end
