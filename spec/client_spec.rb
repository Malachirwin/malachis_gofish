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
    client.puts_result(request.to_json, round_result)
    expect(client.puts_result(request.to_json, round_result)).to eq "player2 did not have a 2 Go fish"
  end
end
