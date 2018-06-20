require 'pry'
require_relative "game"

class GofishServer
  attr_reader :server, :clients_connected, :pending_clients, :pending_clients_four_player, :games
  attr_reader :pending_clients_three_player, :pending_clients_five_player, :pending_clients_six_player
  def initialize
    @turn = 0
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
    @pending_clients.push(client)
    client.puts "Welcome to Gofish, How many players do you want to play with?"
    @clients_connected += 1
  rescue IO::WaitReadable, Errno::EINTR
    #puts "No client to accept"
  end

  def create_game_if_possible
    clients_to_remove_from_pending = []
    @pending_clients.each do |client|
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
    if pending_clients_four_player.count > 3
      game = GofishGame.new
      game.start(4)
      pending_clients_four_player.each.with_index do |client, index|
        client.puts "The game is starting"
        client.puts "player#{index + 1}"
      end
      @games.store(game, pending_clients_four_player.shift(4))
      return game
    end
    if pending_clients_three_player.count > 2
      game = GofishGame.new
      game.start(3)
      pending_clients_three_player.each.with_index do |client, index|
        client.puts "The game is starting"
        client.puts "player#{index + 1}"
      end
      @games.store(game, pending_clients_three_player.shift(3))
      return game
    end
    if pending_clients_five_player.count > 4
      game = GofishGame.new
      game.start(5)
      pending_clients_five_player.each.with_index do |client, index|
        client.puts "The game is starting"
        client.puts "player#{index + 1}"
      end
      @games.store(game, pending_clients_five_player.shift(5))
      return game
    end
    if pending_clients_six_player.count > 5
      game = GofishGame.new
      game.start(6)
      pending_clients_six_player.each.with_index do |client, index|
        client.puts "The game is starting"
        client.puts "player#{index + 1}"
      end
      @games.store(game, pending_clients_six_player.shift(6))
      return game
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
