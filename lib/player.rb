require "json"
class Player
  def initialize(name, cards=[])
    @cards = cards
    @name = name
    @match = []
  end

  def player_hand
    @cards
  end

  def name
    @name
  end

  def to_json(options = {})
    {name: name, hand: player_hand}.to_json
  end

  def cards_left
    player_hand.count
  end

  def set_hand(cards)
    @cards = *cards
  end

  def match(matches)
    @match << matches
  end

  def points
    @match.count
  end

  def matches
    @match
  end

  def take(cards)
    @cards.push(*cards)
  end
end
