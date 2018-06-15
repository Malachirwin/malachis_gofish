require_relative "request"
require "socket"
require "pry"
require 'colorize'
require_relative "client"

while true
  begin
    client = Client.new("Malachi")
    welcome_message = client.get_stuff
    puts welcome_message
    puts "#Note your answer has to be an integer between 3 and 6"
    client.ask_for_integer
    game_is_starting = client.get_stuff
    puts game_is_starting
    player_name = client.get_stuff
    puts "you are #{player_name}"
    puts client.example
    while true
      begin
        message = client.get_stuff
        return if message.nil?
        if message == "It is your turn\n"
          puts message
          client.ask_for_input
        elsif message == "you can't ask that\n"
          puts message
          puts "ERROR: -!-INVALID REQUEST-!-".light_red
          puts client.example
        elsif message.include?('Result: ')
          round_result = message.gsub('Result: ', '')
          request = client.get_stuff
          puts client.puts_result(request, round_result, player_name) if client.puts_result(request, round_result, player_name)
        else
          print message
        end
      rescue #Exception => e
        #puts e.message
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
