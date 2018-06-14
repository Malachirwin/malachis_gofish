require_relative "request"
require "socket"
require "pry"
require 'colorize'

class Client
  attr_reader :socket
  def initialize(name)
    @socket = TCPSocket.new 'localhost', 5003
    @name = name
  end

  def name
    @name
  end

  def ask_for_input
    answer = gets
    socket.puts answer
  end

  def provide_input(text)
    socket.puts text
  end

  def recieve_output_from_server
    socket.gets
  end

  def puts_result(request, round_result)
    new_request = Request.from_json(request)
    if round_result == "Go fish\n"
      return "#{new_request.player_who_asked} asked #{new_request.player_who_was_asked} but #{new_request.player_who_was_asked} did not have a #{new_request.desired_rank} Go fish"
    elsif round_result == "you can't ask that\n"
      return "ERROR: -!-#{new_request.player_who_asked} YOU CAN'T ASK THAT-!-".red
    else
      return "#{new_request.player_who_was_asked} gave #{round_result.chomp} to #{new_request.player_who_asked}"
    end
  end
end
