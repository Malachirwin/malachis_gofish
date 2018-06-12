require 'request'
require 'json'

describe 'request' do
  it 'test reading request' do
    request = Request.new("2")
    expect(request.read).to eq "2"
  end

  it 'test to_json' do
    request = Request.new(2)
    expect(request.to_json).to eq "2"
  end

  it 'test parse' do
    request = Request.new(2)
    request = request.to_json
    expect(JSON.parse(request)).to eq 2
  end

  it "test request of player to ask player to give cards and rank of card they want to json" do
    request = Request.new(["player1", "player2", 3])
    request = request.to_json
    expect(request).to eq "[\"player1\",\"player2\",3]"
  end

  it "test request of player to ask player to give cards and rank of card they want to json" do
    card = Card.new('H', 6)
    request = Request.new(card)
    request = request.to_json
    expect(request).to eq "\"#{card}\""
  end

  it "test request of player to ask player to give cards and rank of card they want to parse" do
    request = Request.new(["player1", "player2", 3])
    request = request.to_json
    expect(JSON.parse(request)).to eq ["player1","player2",3]
  end
end
