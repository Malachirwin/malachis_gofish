require 'pry'
require 'json'

class GofishGame

  def initialize
    @games ||= 0
  end

  def start
    @deck = CardDeck.new
    @player1 = Player.new("player1")
    @player2 = Player.new("player2")
    @player3 = Player.new("player3")
    @player4 = Player.new("player4")
    @deck.deal(@deck, @player1, @player2, @player3, @player4)
    @games += 1
  end

  def num_of_games
    @games
  end

  def player_set_hand(player_number, cards)
    if player_number == 1
      player1.set_hand(cards)
    elsif player_number == 2
      player2.set_hand(cards)
    elsif player_number == 3
      player3.set_hand(cards)
    else
      player4.set_hand(cards)
    end
  end

  def find_player(player_number)
    if player_number == 1
      player1
    elsif player_number == 2
      player2
    elsif player_number == 3
      player3
    else
      player4
    end
  end


  def card_in_player_hand(player_to_search, rank, player_to_give_cards)
    # Takes player string name and finds the player.
    # player = find_player(name[-1].to_i)
    # player_to_give_cards = find_player(player_who_asked[-1].to_i)
    player_to_search.player_hand.each do |card_from_player|
      if rank == card_from_player.rank
        player_to_search.player_hand.delete(card_from_player)
        player_to_give_cards.take(card_from_player)
        return "player has a #{rank}"
      end
    end
    player_to_give_cards.take(deck.remove_top_card)
    return "Go fish"
  end

  private

  def deck
    @deck
  end
  attr_reader :player1, :player2, :player3, :player4
end
