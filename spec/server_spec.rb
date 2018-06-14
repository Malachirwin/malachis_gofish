require 'socket'
require 'game'
require 'pry'
require "server"
require "request"

class MockSocketClient
  attr_reader :socket, :sockets, :output
  def initialize(port)
    @sockets ||= []
    @socket = TCPSocket.new "localhost", port
  end

  def capture_output(delay=0.001)
    sleep(delay)
    @output = socket.read_nonblock(1000)
  rescue IO::WaitReadable
    @output = ""
  end

  def provide_input(text)
    socket.puts(text)
  end

  def close
    socket.close if socket
  end
end

describe "Server" do

  it "is not listening on a port baefore server is started" do
    server = GofishServer.new
    expect {MockSocketClient.new(server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  context "server" do
    let (:server) {GofishServer.new}
    before do
      server.start
      @clients = []
    end

    after do
      server.stop
      if @clients != nil
        @clients.each do |client|
          client.close
        end
      end
    end

    it "accept new clients if there are any and puts a message to them" do
      client1 = MockSocketClient.new(server.port_number)
      server.accept_new_client
      expect(server.clients_connected).to eq 1
      expect(client1.capture_output).to eq "Welcome to Gofish, How many players do you want to play with?\n"
    end
    context "creates game with four players" do
      let(:server) {GofishServer.new}
      let(:client1) {MockSocketClient.new(server.port_number)}
      let(:client2) {MockSocketClient.new(server.port_number)}
      let(:client3) {MockSocketClient.new(server.port_number)}
      let(:client4) {MockSocketClient.new(server.port_number)}
      let(:client5) {MockSocketClient.new(server.port_number)}
      let(:client6) {MockSocketClient.new(server.port_number)}
      let(:client7) {MockSocketClient.new(server.port_number)}
      let(:client8) {MockSocketClient.new(server.port_number)}
      let(:client9) {MockSocketClient.new(server.port_number)}
      before do
        @clients << client1
        @clients << client2
        @clients << client3
        @clients << client4
        @clients << client5
        @clients << client6
        @clients << client7
        @clients << client8
        @clients << client9
        server.accept_new_client
        server.accept_new_client
        server.accept_new_client
        server.accept_new_client
        server.accept_new_client
        server.accept_new_client
        server.accept_new_client
        server.accept_new_client
        server.accept_new_client
      end

      it "with three players two six players" do
        client1.provide_input "3"
        client2.provide_input "3"
        client3.provide_input "3"
        server.create_game_if_possible
        expect(server.game_count).to eq 1
        client4.provide_input "6"
        client5.provide_input "6"
        client6.provide_input "6"
        client7.provide_input "6"
        client8.provide_input "6"
        client9.provide_input "6"
        server.create_game_if_possible
        expect(server.game_count).to eq 2
      end

      it "runs the round" do
        client1.provide_input "3"
        client2.provide_input "3"
        client3.provide_input "3"
        game = server.create_game_if_possible
        client1.capture_output
        client2.capture_output
        client3.capture_output
        server.tell_clients_whos_turn(game)
        expect(client1.capture_output).to eq "It is your turn\n"
        client1.provide_input "player1, do you have a 3"
        game.player_set_hand(1, Card.new("H", 2))
        server.run_round(game)
        expect(client1.capture_output).to eq "3 of Hearts\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player1\",\"desired_rank\":\"3\"}\n"
      end
      context "After game is created" do
        before do
          client1.provide_input "3"
          client2.provide_input "3"
          client3.provide_input "3"
          client1.capture_output
          client2.capture_output
          client3.capture_output
        end
        let(:game) {game = server.create_game_if_possible}
        it "sould be able to run a couple rounds" do
          game.player_set_hand(2, [Card.new("H", 2), Card.new("D", 8)])
          game.player_set_hand(3, [Card.new("H", 2), Card.new("D", 5)])
          game.player_set_hand(1, [Card.new("H", 2), Card.new("D", 6)])
          expect(client2.capture_output).to eq "The game is starting\nplayer2\n"
          expect(client3.capture_output).to eq "The game is starting\nplayer3\n"
          expect(client1.capture_output).to eq "The game is starting\nplayer1\n"
          server.tell_clients_their_cards(game)
          expect(client2.capture_output).to eq "3 of Hearts, 9 of Diamonds\n"
          expect(client3.capture_output).to eq "3 of Hearts, 6 of Diamonds\n"
          expect(client1.capture_output).to eq "3 of Hearts, 7 of Diamonds\n"
          server.tell_clients_whos_turn(game)
          expect(client1.capture_output).to eq "It is your turn\n"
          client1.provide_input "player3, do you have a 3"
          game.player_set_hand(2, [Card.new("H", 2), Card.new("D", 8)])
          game.player_set_hand(3, [Card.new("H", 2), Card.new("D", 5)])
          game.player_set_hand(1, [Card.new("H", 2), Card.new("D", 6)])
          server.run_round(game)
          expect(client1.capture_output).to eq  "3 of Hearts\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"3\"}\n"
          expect(client2.capture_output).to eq "3 of Hearts\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"3\"}\n"
          expect(client3.capture_output).to eq "3 of Hearts\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"3\"}\n"
          client1.capture_output
          server.tell_clients_whos_turn(game)
          expect(client1.capture_output).to eq "It is your turn\n"
          client1.provide_input "player3, do you have a 7"
          game.player_set_hand(2, [Card.new("H", 2), Card.new("D", 8)])
          game.player_set_hand(3, [Card.new("H", 2), Card.new("D", 5)])
          game.player_set_hand(1, [Card.new("H", 2), Card.new("D", 6)])
          server.run_round(game)
          expect(client1.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"7\"}\n"
          expect(client2.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"7\"}\n"
          expect(client3.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"7\"}\n"
          server.tell_clients_whos_turn(game)
          expect(client2.capture_output).to eq "It is your turn\n"
          client2.provide_input "player1, do you have a 9"
          game.player_set_hand(2, [Card.new("H", 2), Card.new("D", 8)])
          game.player_set_hand(3, [Card.new("H", 2), Card.new("D", 5)])
          game.player_set_hand(1, [Card.new("H", 2), Card.new("D", 6)])
          server.run_round(game)
          expect(client2.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player2\",\"player_who_was_asked\":\"player1\",\"desired_rank\":\"9\"}\n"
          expect(client1.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player2\",\"player_who_was_asked\":\"player1\",\"desired_rank\":\"9\"}\n"
          expect(client3.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player2\",\"player_who_was_asked\":\"player1\",\"desired_rank\":\"9\"}\n"
          server.tell_clients_whos_turn(game)
          expect(client3.capture_output).to eq "It is your turn\n"
          client3.provide_input "player2, do you have a 6"
          game.player_set_hand(2, [Card.new("H", 2), Card.new("D", 8)])
          game.player_set_hand(3, [Card.new("H", 2), Card.new("D", 5)])
          game.player_set_hand(1, [Card.new("H", 2), Card.new("D", 6)])
          server.run_round(game)
          expect(client3.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player3\",\"player_who_was_asked\":\"player2\",\"desired_rank\":\"6\"}\n"
          expect(client2.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player3\",\"player_who_was_asked\":\"player2\",\"desired_rank\":\"6\"}\n"
          expect(client1.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player3\",\"player_who_was_asked\":\"player2\",\"desired_rank\":\"6\"}\n"
          server.tell_clients_whos_turn(game)
          expect(client1.capture_output).to eq "It is your turn\n"
          client1.provide_input "ask player3 for 7"
          game.player_set_hand(2, [Card.new("H", 2), Card.new("D", 8)])
          game.player_set_hand(3, [Card.new("H", 2), Card.new("D", 5)])
          game.player_set_hand(1, [Card.new("H", 2), Card.new("D", 6)])
          server.run_round(game)
          expect(client1.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"7\"}\n"
          expect(client2.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"7\"}\n"
          expect(client3.capture_output).to eq "Go fish\n{\"player_who_asked\":\"player1\",\"player_who_was_asked\":\"player3\",\"desired_rank\":\"7\"}\n"
        end
      end
    end
  end
end
