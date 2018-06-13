require 'pry'

class GofishServer
  attr_reader :server, :clients_connected, :pending_clients, :pending_clients_four_player
  attr_reader :pending_clients_three_player, :pending_clients_five_player, :pending_clients_six_player
  def initialize
    @clients_connected = 0
    @pending_clients = []
    @pending_clients_three_player = []
    @pending_clients_four_player = []
    @pending_clients_five_player = []
    @pending_clients_six_player = []
    @games = {}
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    server.close if server
  end

  def port_number
    5003
  end

  def game_count
    @games.count
  end

  def accept_new_client
    client = server.accept_nonblock
    @pending_clients.push(client)
    client.puts "Welcome to Gofish, How many players do you want to play with?\n"
    @clients_connected += 1
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    clients_to_remove_from_pending = []
    pending_clients.each do |client|
      client_input = capture_output(client)
      if client_input == "4\n"
        pending_clients_four_player.push(client)
        clients_to_remove_from_pending.push(client)
      elsif client_input == "3\n"
        pending_clients_three_player.push(client)
        clients_to_remove_from_pending.push(client)
      elsif client_input == "5\n"
        pending_clients_five_player.push(client)
        clients_to_remove_from_pending.push(client)
      elsif client_input == "6\n"
        pending_clients_six_player.push(client)
        clients_to_remove_from_pending.push(client)
      end
    end
    clients_to_remove_from_pending.each do |client|
      pending_clients.delete(client)
    end
    if pending_clients_four_player.count >3
      game = GofishGame.new
      game.start(4)
      @games.store(game, pending_clients_four_player.shift(4))
    end
    if pending_clients_three_player.count > 2
      game = GofishGame.new
      game.start(3)
      @games.store(game, pending_clients_three_player.shift(3))
    end
    if pending_clients_five_player.count > 4
      game = GofishGame.new
      game.start(5)
      @games.store(game, pending_clients_five_player.shift(5))
    end
    if pending_clients_six_player.count > 5
      game = GofishGame.new
      game.start(6)
      @games.store(game, pending_clients_six_player.shift(6))
    end
  end

  

  private
  def capture_output(delay=0.000001, client)
    sleep(delay)
    output = client.read_nonblock(1000)
  rescue IO::WaitReadable
    output = ""
  end
end
