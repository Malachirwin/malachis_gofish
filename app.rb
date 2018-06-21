require "./lib/request"
require "pry"
require "sinatra"
require "sinatra/reloader"
require './lib/encrypting_and_decrypting'
require "./lib/game"
require 'pusher'

$clients = []
$game = nil
$results = []

class App < Sinatra::Base
  MESSAGE_KEY = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt.random_key
  NUMBER_OF_PLAYERS = 4
  def pusher_client
    @pusher_client ||= Pusher::Client.new(
      app_id: "547002",
      key: "e09b3296658d893c5367",
      secret: "1b2821037b4218f1ee2c",
      cluster: "us2"
    )
  end

  get("/") do
    slim(:welcome_join)
  end

  post('/join_game') do
    if $clients.length > NUMBER_OF_PLAYERS
      return redirect "/please_wait"
    end
    client = params["name"]
    $clients.push(client)
    client_number = $clients.length - 1
    $message = "yes"
    redirect("/waiting?name=#{encrypt_client_name client}")
  end

  get("/waiting") do
    if $clients.length == NUMBER_OF_PLAYERS
      if $message == "yes"
        $message = "no"
        pusher_client.trigger('app', 'Game-is-starting', {message: 'Game is starting'})
      end
      $game ||= GofishGame.new
      if $game.players == nil
        $game.start(NUMBER_OF_PLAYERS, $clients)
      end
      $result = "The game is starting"
      redirect("/playing_game?name=#{encrypt_client_name client_name}")
    else
      slim(:waiting)
    end
  end

  get "/please_wait" do
    slim :please_wait
  end

  post "/playing_game" do
    if client_name == $game.player_who_is_playing.name
      @turn = true
    end
    request = params["request"]
    regex = /ask\s(\w+).*\s(\w{2}|\w{1})/i
    if request.match(regex)
      matches = request.match(regex).captures
      if matches[0] == $game.players[$game.player_turn - 1].name
        redirect("/playing_game?name=#{encrypt_client_name client_name}")
      else
        request = Request.new(client_name, matches[0], matches[1])
        result = $game.do_turn(request)
        if result == "you can't ask that"
          return redirect("/playing_game?name=#{encrypt_client_name client_name}")
        end
        @other_players = $game.players.reject { |player| player.name == client_name }
        $message = "yes"
        # binding.pry
        if result == "Go fish"
          final_result = "#{client_name} asked #{matches[0]} for a #{matches[1]} but #{matches[0]} did not have one"
        else
          final_result = "#{matches[0]} gave #{client_name} the #{result}"
        end
        $results.push(final_result)
        redirect("/playing_game?name=#{encrypt_client_name client_name}")
      end
    else
      redirect("/playing_game?name=#{encrypt_client_name client_name}")
    end
  end

  get("/playing_game") do
    if $message == "yes"
      $message = "no"
      pusher_client.trigger('app', 'next-turn', {message: "next turn"})
    end
    if client_name == $game.player_who_is_playing.name
      @turn = true
    end
    @other_players = $game.players.reject { |player| player.name == client_name }
    slim(:go_fish)
  end

  private

  def client_number
    @client_number ||= decrypt_client_number(params['client_number'])
  end

  def client_name
    @client_name ||= decrypt_client_name(params["name"])
  end

  def encrypt_client_number(number)
    "hello-#{number}-dolly".encrypt(MESSAGE_KEY)
  end

  def encrypt_client_name(name)
    name.encrypt(MESSAGE_KEY)
  end

  def decrypt_client_number(text)
    text.decrypt(MESSAGE_KEY).split('-')[1].to_i
  end

  def decrypt_client_name(text)
    text.decrypt(MESSAGE_KEY).split('-')[0]
  end
end
