require 'rspec'
require 'card'

describe 'Card' do
  it 'returns the suit' do
    card = Card.new('H', 1)
    expect(card.suit).to eq 'H'
  end

  it 'returns the rank' do
    card = Card.new('H', 1)
    expect(card.rank).to eq 1
  end

  it "goes from a value to a card" do
    card_value = "4 of Hearts"
    card = Card.from_value(card_value)
    expect(card.rank).to eq 3
    expect(card.suit).to eq "H"
  end

  it "takes a card and turns in into the right thing for finding the card in cards folder" do
    card = Card.new('H', 10)
    expect(card.to_img_path).to eq "hj"
  end

  it "takes a card and turns in into the right thing for finding the card in cards folder" do
    card = Card.new('H', 2)
    expect(card.to_img_path).to eq "h3"
  end
end
