require "socket"
require_relative "server"
require "pry"

server = GofishServer.new
server.start
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  if game
    Thread.new { server.run_game(game) }
  end
  sleep(2)
rescue
  server.stop
end
