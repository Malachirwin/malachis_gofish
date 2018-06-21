require 'pry'
require 'json'
require_relative "card_deck"
require_relative "player"
require_relative "request"

class GofishGame
  attr_reader :deck
  def initialize
    @games ||= 0
    @player_turn = 1
  end

  def start(number_of_players, names=["player1", "player2", "player3", "player4"])
    @deck = CardDeck.new
    @players = []
    number_of_players.times do |index|
      @players << Player.new(names[index])
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
    begin
      player_to_give_cards.player_hand.each do |card|
        if rank.to_s == card.rank_value
          player_to_ask.player_hand.each do |card_from_player|
            if rank.to_s == card_from_player.rank_value
              player_to_give_cards.take(card_from_player)
              player_to_ask.player_hand.delete(card_from_player)
              return card_from_player.value
            end
          end
          player_to_give_cards.take(deck.remove_top_card)
          next_turn
          return "Go fish"
        end
      end
      return "you can't ask that"
    rescue NoMethodError
      return "you can't ask that"
    end
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
    begin
      players.each do |player|
        matches = []
        player.player_hand.each do |card|
          value_of_card = card.rank_value
          player.player_hand.each do |next_card|
            if value_of_card == next_card.rank_value
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
    rescue NoMethodError
      #nothing todo
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
      game_end
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
    result
  end

  def players
    @players
  end

  def player_who_is_playing
    players[player_turn - 1]
  end

  def cards_left_in_deck
    deck.cards_left
  end

  private
  attr_reader :deck
end
