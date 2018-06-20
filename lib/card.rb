class Card
  SUITS = {'H' => 'Hearts' ,'D' => 'Diamonds', 'S' => 'Spades', 'C' => 'Clubs'}
  RANKS = {1 => '2', 2 => '3', 3 => '4', 4 => '5', 5 => '6', 6 => '7', 7 => '8', 8 => '9', 9 => '10', 10 => 'J', 11 => 'Q', 12 => 'K', 13 => 'A'}

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def self.from_value(value)
    rank, suit = value.split(" of ")
    card_rank = RANKS.key(rank)
    card_suit = suit[0]
    Card.new(card_suit, card_rank)
  end

  def to_img_path
    "#{suit.downcase}#{rank_value.downcase}"
  end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def rank_value
    RANKS[rank]
  end

  def value
    "#{RANKS[rank]} of #{SUITS[suit]}"
  end
end
