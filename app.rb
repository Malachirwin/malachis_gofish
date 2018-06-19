require "./lib/client"
require "pry"
require "sinatra"
require "sinatra/reloader"
Thread.new { require "./lib/socket_runner.rb" }

$clients = []

class App < Sinatra::Base
  get("/") do
    slim(:welcome_join)
  end

  post('/join_game') do
    client = Client.new
    $clients << client
    client.get_stuff
    client.tell_server("4")
    @client_number = $clients.length - 1
    redirect("/waiting?client_number=#{@client_number}")
  end

  get("/waiting") do
    if $clients.length >= 4
      redirect("/game?client_number=#{params["client_number"]}")
    else
      slim(:waiting)
    end
  end

  get("/game") do
    client = $clients[params["client_number"].to_i]
    client.get_stuff
    client.get_stuff
    $cards_or_message = client.get_stuff
    if $cards_or_message == "It is your turn\n"
      @cards = client.get_stuff
    end
    redirect("/playing_game?client_number=#{params["client_number"]}")
  end

  get("/playing_game") do
    @players = ["player1", "player2", "player3", "player4"]
    @cards = $cards_or_message
    slim(:go_fish)
  end
end
