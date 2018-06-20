require 'pry'
require_relative "game"

class GofishServer
  attr_reader :server, :clients_connected, :pending_client_players, :pending_clients, :games

  def initialize
    @turn = 0
    @clients_connected = 0
    @pending_clients = []
    @pending_client_players = {}
    @games = {}
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def tell_clients(text)
    server.puts text
  end

  def stop
    server.close if server
  end

  def port_number
    5005
  end

  def game_count
    @games.count
  end

  def accept_new_client
    client = server.accept_nonblock
    pending_clients.push(client)
    client.puts "Welcome to Gofish, How many players do you want to play with?"
    @clients_connected += 1
  rescue IO::WaitReadable, Errno::EINTR
    #puts "No client to accept"
  end

  def create_game_if_possible
    clients_to_remove_from_pending = []
    pending_clients.each do |client|
      client_input = capture_output(client)
      value = client_input.to_i
      if value >= 3 && value <= 6
        pending_client_players[value] ||= []
        pending_client_players[value].push(client)
        clients_to_remove_from_pending.push(client)
      end
    end
    clients_to_remove_from_pending.each do |client|
      pending_clients.delete(client)
    end
    pending_client_players.each do |requested_number, clients|
      if clients.length == requested_number
        game = GofishGame.new
        game.start(requested_number)
        clients.each.with_index do |client, index|
          client.puts "The game is starting"
          client.puts "player#{index + 1}"
        end
        games.store(game, clients)
        pending_client_players[requested_number] = []
        return game
      end
    end
  end

  def run_round(game)
    player_number = game.player_turn
    client_to_inform = find_client_by_turn(game)
    clients = find_clients(game)
    request = wait_for_input(client_to_inform)
    regex = /(player\d).*\s(\w+)/i
    if request.match(regex)
      matches = request.match(regex).captures
    else
      client_to_inform.puts "you can't ask that"
      return
    end
    if matches[0] == game.players[game.player_turn - 1].name
      client_to_inform.puts "you can't ask that"
      return
    end
    players_request = Request.new("player#{game.player_turn}", matches[0], matches[1])
    response = game.do_turn(players_request)
    clients.each do |client|
      client.puts "Result: #{response}"
      client.puts players_request.to_json
    end
  end

  def tell_clients_their_cards(game)
    client_playing = find_client_by_turn(game)
    clients = find_clients(game)
    clients.each do |client|
      next if client == client_playing
      client_num = clients.index(client)
      cards = game.players[client_num].player_hand
      client.puts cards.map(&:value).join(', ')
    end
  end

  def tell_clients_playing_cards(game)
    clients = find_clients(game)
    client = find_client_by_turn(game)
    client_num = clients.index(client)
    cards = game.players[client_num].player_hand
    client.puts cards.map(&:value).join(', ')
  end

  def run_game(game)
    clients = find_clients(game)
    until game.winner
      if turn != game.player_turn
        @turn = game.player_turn
        tell_clients_their_cards(game)
      else
        tell_clients_playing_cards(game)
        tell_clients_whos_turn(game)
        run_round(game)
      end
    end
    clients.each {|c| c.puts game.winner}
  end

  def wait_for_input(client)
    client_input = ''
    until client_input != ""
      client_input = capture_output(client)
    end
    client_input
  end

  def tell_clients_whos_turn(game)
    client = find_client_by_turn(game)
    client.puts "It is your turn"
  end

  private

  def turn
    @turn
  end
  def find_clients(game)
    games.fetch(game)
  end

  def find_client_by_turn(game)
    clients = games.fetch(game)
    which_turn = (game.player_turn - 1)
    client = clients[which_turn]
    return client
  end

  def capture_output(delay=0.0000001, client)
    sleep(delay)
    output = client.read_nonblock(1000)
  rescue IO::WaitReadable
    output = ""
  end
end
