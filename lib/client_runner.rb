require_relative "request"
require "socket"
require "pry"
require 'colorize'
require_relative "client"

while true
  begin
    client = Client.new("Malachi")
    welcome_message = client.socket.gets
    puts welcome_message
    client.ask_for_input
    game_is_starting = client.socket.gets
    puts game_is_starting
    player_name = client.socket.gets
    puts "you are #{player_name}"

    # {messages: ['welcome', 'start', 'your turn'], your_turn: true}
    # {messages: ['result'], hand: ['K of S'], your_turn: false}

    while true
      begin
        message = client.socket.gets
        return if message.nil?
        if message == "It is your turn\n"
          puts message
          client.ask_for_input
        elsif message == "you can't ask that\n"
          puts message
          puts "ERROR: -!-INVALID REQUEST-!-".red
        elsif message.include?('Result: ')
          round_result = message.gsub('Result: ', '')
          request = client.socket.gets
          puts client.puts_result(request, round_result)
        else
          puts message
        end
      rescue Exception => e
        puts e.message
      end
    end
  rescue Errno::ECONNREFUSED
    puts "Waiting for server to start..."
    sleep(3)
  rescue Errno::EPIPE
    puts "The server was shut down"
  rescue Errno::ECONNRESET
    puts "Sorry there was a problem we will connect you to a different game."
  rescue EOFError
    puts "Game Over"
    break
  end
end
