require "./lib/client"
require "pry"
require "sinatra"
require "sinatra/reloader"
require './lib/encrypting_and_decrypting'
Thread.new { require "./lib/socket_runner.rb" }

$clients = {}

class App < Sinatra::Base
  MESSAGE_KEY = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt.random_key
  NUMBER_OF_PLAYERS = 4

  get("/") do
    slim(:welcome_join)
  end

  post('/join_game') do
    if $clients.keys.length >= NUMBER_OF_PLAYERS
      return redirect "/please_wait"
    end
    client = Client.new
    $clients[client] = []
    client.get_stuff
    client.tell_server(NUMBER_OF_PLAYERS.to_s)
    client_number = $clients.keys.length - 1
    redirect("/waiting?client_number=#{encrypt_client_number client_number}")
  end

  get("/waiting") do
    if $clients.keys.length % NUMBER_OF_PLAYERS == 0
      redirect("/game?client_number=#{encrypt_client_number client_number}")
    else
      slim(:waiting)
    end
  end

  get "/please_wait" do
    slim :please_wait
  end

  get("/game") do
    client = $clients.keys[client_number]
    m1 = client.get_stuff
    m2 = client.get_stuff
    cards_or_message = client.get_stuff
    $clients[client] = cards_or_message.chomp.split(", ")
    if client.read_stuff == "It is your turn\n"
      redirect("/playing_game?turn=true&client_number=#{encrypt_client_number client_number}")
    else
      redirect("/playing_game?client_number=#{encrypt_client_number client_number}")
    end
  end

  get("/playing_game") do
    @player = "player#{client_number + 1}"
    @other_players = $clients.map.with_index do |client, index|
      "player#{index + 1}"
    end.reject do |name|
      name == @player
    end
    @cards = cards
    slim(:go_fish)
  end

  private

  def client_number
    @client_number ||= decrypt_client_number(params['client_number'])
  end

  def cards
    $clients.values[client_number].map do |card|
      Card.from_value(card)
    end
  end

  def encrypt_client_number(number)
    "hello-#{number}-dolly".encrypt(MESSAGE_KEY)
  end

  def decrypt_client_number(text)
    text.decrypt(MESSAGE_KEY).split('-')[1].to_i
  end
end
