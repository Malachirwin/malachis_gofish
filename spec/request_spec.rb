require 'request'
require 'json'

describe 'request' do
  let(:player1) {"player2"}
  let(:player2) {"player1"}
  it "test request of player to ask player to give cards and rank of card they want to json" do
    desired_rank = 5
    request = Request.new(player1, player2, desired_rank)
    json_request = request.to_json
    new_request = Request.from_json(json_request)
    expect(new_request.player_who_asked).to eq request.player_who_asked
    expect(new_request.player_who_was_asked).to eq request.player_who_was_asked
    expect(new_request.desired_rank).to eq request.desired_rank
  end
end
