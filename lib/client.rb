require_relative "request"
require "socket"
require "pry"
require 'colorize'

class Client
  attr_reader :socket
  def initialize(name="")
    @socket = TCPSocket.new "localhost", 5005
    @name = name
  end

  def name
    @name
  end

  def read_stuff(delay=0.1)
    sleep(delay)
    socket.read_nonblock(1000)
  rescue
    ''
  end

  def get_stuff
    socket.gets
  end

  def example
    "When asking a player for a rank\n#Note: you can't ask yourself\n#Note: you can only ask for a rank if you have it\n#Note: player names must have no space between player and their number\nlike: \"player1\" not: \"player 1\"\nExample: \"ask player2 for a 4\"\n#Note: face card ranks must be capitals\nExample: \"ask player3 for a K\""
  end

  def ask_for_integer
    answer = ""
    until answer.to_i != 0
      begin
        answer = gets
      rescue
        #nothing to do
      end
    end
    socket.puts answer
  end

  def ask_for_input
    answer = ""
    until answer != ""
      begin
        answer = gets
      rescue
        #nothing to do
      end
    end
    socket.puts answer
  end

  def tell_server(info)
    socket.puts info
  end

  def puts_result(request, round_result, player_name)
    new_request = Request.from_json(request)
    if round_result == "Go fish\n"
      if new_request.player_who_asked == player_name.chomp
        return "you asked #{new_request.player_who_was_asked} for a #{new_request.desired_rank} but #{new_request.player_who_was_asked} did not have a #{new_request.desired_rank} Go fish"
      elsif new_request.player_who_was_asked == player_name.chomp
        return "#{new_request.player_who_asked} asked you for a #{new_request.desired_rank} but you do not have a #{new_request.desired_rank}"
      else
        return "#{new_request.player_who_asked} asked #{new_request.player_who_was_asked} for a #{new_request.desired_rank} but #{new_request.player_who_was_asked} did not have a #{new_request.desired_rank}"
      end
    elsif round_result == "you can't ask that\n"
      if new_request.player_who_asked == player_name.chomp
        return "ERROR: -!-#{new_request.player_who_asked.upcase} YOU CAN'T ASK THAT-!-".light_red
      end
    else
      if new_request.player_who_asked == player_name.chomp
        return "#{new_request.player_who_was_asked} gave #{round_result.chomp} to you"
      elsif new_request.player_who_was_asked == player_name.chomp
        return "you gave #{round_result.chomp} to #{new_request.player_who_asked}"
      else
        return "#{new_request.player_who_was_asked} gave #{round_result.chomp} to #{new_request.player_who_asked}"
      end
    end
  end
end
