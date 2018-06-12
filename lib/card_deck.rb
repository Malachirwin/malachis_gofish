require_relative 'card'

class CardDeck
  def initialize
    @deck = create_deck
  end

  def create_deck
    suits = ['H', 'D', 'S', 'C']
    suits.map do |suit|
      13.times.map do |number|
        rank = number + 1
        Card.new(suit, rank)
      end
    end.flatten
  end

  def shuffle
    card_deck.shuffle!
  end

  def cards_left
    card_deck.length
  end

  def deal(deck, *players)
    shuffle
    players.each do |player_hand|
      5.times do
        player_hand.take(remove_top_card)
      end
    end
    players
  end

  def remove_top_card
    card_deck.shift
  end

  def has_cards?
    if cards_left > 0
      return true
    end
  end

  private

  def card_deck
    @deck
  end
end
