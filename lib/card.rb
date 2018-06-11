class Card
  SUITS = {'H' => 'Hearts' ,'D' => 'Diamonds', 'S' => 'Spades', 'C' => 'Clubs'}
  RANKS = {1 => '2', 2 => '3', 3 => '4', 4 => '5', 5 => '6', 6 => '7', 7 => '8', 8 => '9', 9 => '10', 10 => 'J', 11 => 'Q', 12 => 'K', 13 => 'A'}

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def value
    "#{RANKS[@rank]} of #{SUITS[@suit]}"
  end
end
