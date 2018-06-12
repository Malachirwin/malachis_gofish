require 'json'

class Request
  attr_reader :player_who_asked, :player_who_was_asked, :desired_rank
  def initialize(player_who_asked, player_who_was_asked, desired_rank)
    @player_who_asked = player_who_asked
    @player_who_was_asked = player_who_was_asked
    @desired_rank = desired_rank
  end

  def to_json
    {"player_who_asked" => player_who_asked, "player_who_was_asked" => player_who_was_asked, "desired_rank" => desired_rank}.to_json
  end

  def self.from_json(request)
    data = JSON.parse(request)
    Request.new data['player_who_asked'], data['player_who_was_asked'], data["desired_rank"]
  end
end
