require 'pry'
require 'json'

class GofishGame
  attr_reader :deck
  def initialize
    @games ||= 0
    @player_turn = 1
  end

  def start(number_of_players)
    @deck = CardDeck.new
    @players = []
    number_of_players.times do |index|
      @players << Player.new("player#{index + 1}")
    end
    @deck.deal(@deck, *@players)
    @games += 1
  end

  def num_of_games
    @games
  end

  def clear_deck
    @deck.remove_all_cards_from_deck
  end

  def player_set_hand(player_number, cards)
    find_player(player_number).set_hand(cards)
  end

  def find_player(player_number)
    players[player_number - 1]
  end

  def find_player_by_name(name)
    players.each do |player|
      if player.name == name
        return player
      end
    end
  end

  def card_in_player_hand(player_to_ask, rank, player_to_give_cards)
    player_to_ask.player_hand.each do |card_from_player|
      if rank.to_s == card_from_player.rank_value
        player_to_ask.player_hand.delete(card_from_player)
        player_to_give_cards.take(card_from_player)
        return "player has a #{rank}"
      end
    end
    player_to_give_cards.take(deck.remove_top_card)
    next_turn
    return "Go fish"
  end

  def player_turn
    @player_turn
  end

  def no_cards
    players.each do |player|
      if player.cards_left == 0
        deck.deal(deck, player)
      end
    end
  end

  def next_turn
    if player_turn == players.count
      @player_turn = 1
    else
      @player_turn += 1
    end
  end

  def pair
    players.each do |player|
      matches = []
      player.player_hand.each do |card|
        value_of_card = card.rank_value
        player.player_hand.each do |next_card|
          if value_of_card = next_card.rank_value
            matches << next_card
          end
        end
        if matches.count == 4
          player.match(matches)
          matches.each do |card|
            player.player_hand.delete(card)
          end
        else
          matches = []
        end
      end
    end
  end

  def winner
    result = []
    if deck.has_cards?
    else
      players.each do |player|
        if player.cards_left == 0
          result << true
        else
          result << false
        end
      end
    end
    compare_to_result = []
    players.length.times do
      compare_to_result << true
    end
    if result == compare_to_result
      return true
    else
      return false
    end
  end

  def game_end
    highest_score = 0
    winner = ""
    players.each do |player|
      if player.points > highest_score
        highest_score = player.points
        winner = player
      end
    end
    return "#{winner.name} had the most points with #{highest_score} points"
  end

  def do_turn(player_request)
    player_who_was_asked = find_player_by_name(player_request.player_who_was_asked)
    player_who_asked = find_player_by_name(player_request.player_who_asked)
    result = card_in_player_hand(player_who_was_asked, player_request.desired_rank, player_who_asked)
    pair
    no_cards
    if winner
      game_end
    end
    result
  end

  private
  attr_reader :players, :deck
end
