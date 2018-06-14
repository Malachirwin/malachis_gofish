require "client"
require "pry"
require "server"
describe "Client" do
  let(:server) {GofishServer.new}
  before do
    server.start
  end

  after do
    server.stop
  end

  it "creates a client" do
    client = Client.new("Malachi")
    expect(client.name).to eq "Malachi"
  end

  it "returns correct output to client from a request" do
    client = Client.new("Malachi")
    request = Request.new("player1", "player2", 2)
    round_result = "Go fish\n"
    expect(client.puts_result(request.to_json, round_result, "player1")).to eq "you asked player2 for a 2 but player2 did not have a 2 Go fish"
  end

  it "puts the Examples" do
    client = Client.new("player1")
    expect(client.example).to eq "When asking a player for a rank\n#Note: you can't ask yourself\n#Note: you can only ask for a rank if you have it\n#Note: player names must have no space between player and their number\nlike: \"player1\" not: \"player 1\"\nExample: \"ask player2 for a 4\"\n#Note: face card ranks must be capitals\nExample: \"ask player3 for a K\""
  end
end
