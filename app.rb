require "./lib/client"
require "pry"
require "sinatra"
require "sinatra/reloader"
require './lib/encrypting_and_decrypting'
Thread.new { require "./lib/socket_runner.rb" }

$clients = []

class App < Sinatra::Base
  MESSAGE_KEY = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt.random_key

  get("/") do
    slim(:welcome_join)
  end

  post('/join_game') do
    if $clients.length >= 4
      return redirect "/please_wait"
    end
    client = Client.new
    $clients << client
    client.get_stuff
    client.tell_server("4")
    client_number = $clients.length - 1
    redirect("/waiting?client_number=#{encrypt_client_number client_number}")
  end

  get("/waiting") do
    if $clients.length % 4 == 0
      redirect("/game?client_number=#{encrypt_client_number client_number}")
    else
      slim(:waiting)
    end
  end

  get "/please_wait" do
    slim :please_wait
  end

  get("/game") do
    client = $clients[client_number]
    client.get_stuff
    client.get_stuff
    $cards_or_message = client.get_stuff
    if $cards_or_message == "It is your turn\n"
      @cards = client.get_stuff
    end
    redirect("/playing_game?client_number=#{encrypt_client_number client_number}")
  end

  get("/playing_game") do
    @client_number = client_number
    @players = ["player1", "player2", "player3", "player4"]
    @cards = $cards_or_message
    slim(:go_fish)
  end

  private

  def client_number
    @client_number ||= decrypt_client_number(params['client_number'])
  end

  def encrypt_client_number(number)
    "hello-#{number}-dolly".encrypt(MESSAGE_KEY)
  end

  def decrypt_client_number(text)
    text.decrypt(MESSAGE_KEY).split('-')[1].to_i
  end
end
