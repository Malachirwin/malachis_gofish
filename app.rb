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
    if $clients.length >= 4
      return redirect("/game?client_number=#{@client_number}")
    end
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
    slim(:go_fish)
  end
end
