require "./../lib/request"
require "pry"
require "sinatra"
require "sinatra/reloader"
require './../lib/encrypting_and_decrypting'
require "./../lib/game"
require "json"
require "sinatra/json"
require "./../lib/request"
$game = nil
$results = []
class App < Sinatra::Base
  MESSAGE_KEY = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt.random_key
  NUMBER_OF_PLAYERS = 4
  russain_american_names = ["Aleksandr", "Aleksey", "Alex", "Alexander", "Alexandr", "Alexandra", "Alexey", "Alexis", "Alper", "Andrej", "Andrew", "Andrey", "Anton", "Anya", "Artem", "Arthur", "Artur", "Artym", "Artyom", "Aytal", "Baldan", "Borislav", "Collosus", "Dan", "Daniel", "Daniil", "Danilov", "Dave", "Denis", "Dima", "Dmitrii", "Dmitriy", "Dmitry", "Dominique", "Donatien", "Edward", "Fabrice", "Fayad", "Gena", "Gleb", "Grairik", "Grechihckin", "Hamza", "Igor", "Ilushka", "Ilya", "Ivan", "Kirill", "Kirill", "Nikonov", "Kolya", "Konstantin", "Kostya", "Lex", "Max", "Maxim", "Maximka", "Mikhail", "Murad", "Nastya", "Nick", "Nicky", "Nike", "Nikita", "Oleg", "Omer", "Ostin", "Pasha", "Paul", "Pavel", "Pawel", "Philip", "Raoul", "Rodion", "Roma", "Roman", "Ruslan", "Sacha", "Samuele", "Sasha", "Sebastian", "Serge", "Sergei", "Sergey", "Stas", "Thierry", "Tseden", "Uche", "Vadim", "Vadmas", "Valera", "Vanya", "Vasiliy", "Vlad", "Vladimir", "Vladislav", "Vova", "Will", "Yegor", "Yura", "Yuri", "Aigul", "Aleksandra", "Alena", "Alex", "Alexandra", "Alice", "Alina", "Alisa", "Alla", "Alyona", "Anastasia", "Anastasiya", "Ann", "Anna", "Anny", "Anya", "Arina", "Catherine", "Chimita", "Christine", "Daria", "Darya", "Dasha", "Diana", "Dinara", "Ekaterina", "Elena", "Evgenia", "Galina", "Galya", "Gulnaz", "Guzel", "Helen", "Inna", "Irene", "Irina", "Jane", "Julia", "Julie", "Karina", "Kate", "Katerina", "Katia", "Katy", "Katya", "Kristina", "Ksenia", "Kseniya", "Ksusha", "Lana", "Lena", "Lera", "Liliya", "Lina", "Lisa", "Liza", "Luba", "Lyuba", "Margarita", "Maria", "Marie", "Marina", "Mariya", "Mary", "Masha", "Nadya", "Nastia", "Nastya", "Natalia", "Natalie", "Nataly", "Natalya", "Natasha", "Nina", "Oksana", "Olesya", "Olga", "Olya", "Pauline", "Polina", "Regina", "Sasha", "Sofia", "Sonya", "Sveta", "Svetlana", "Tanya", "Tatiana", "Tatyana", "Valentina", "Valeria", "Valerie", "Varya", "Vera", "Veronika", "Victoria", "Vika", "Yana", "Yulia", "Zhanna"]
  array_of_names = ["Sophia", "Jackson", "Olivia", "Liam", "Emma", "Noah", "Ava", "Aiden", "Isabella", "Lucas", "Mia", "Caden", "Aria",	"Grayson", "Riley",	"Mason", "Zoe", "Elijah", "Amelia",	"Logan", "Layla",	"Oliver", "Charlotte",	"Ethan", "Aubrey",	"Jayden", "Lily",	"Muhammad", "Chloe",	"Carter", "Harper",	"Michael", "Evelyn",	"Sebastian", "Adalyn",	"Alexander", "Emily",	"Jacob", "Abigail",	"Benjamin", "Madison",	"James", "Aaliyah",	"Ryan", "Avery",	"Matthew", "Ella",	"Daniel", "Scarlett",	"Jayce", "Maya",	"Mateo", "Mila",	"Caleb", "Nora",	"Luke", "Camilla",	"Julian", "Arianna",	"Jack", "Eliana",	"William", "Hannah",	"Wyatt", "Leah",	"Gabriel", "Ellie",	"Connor", "Kaylee",	"Henry", "Kinsley",	"Isaiah", "Hailey",	"Isaac", "Madelyn",	"Owen", "Paisley",	"Levi", "Elizabeth",	"Cameron", "Addison",	"Nicholas", "Isabelle",	"Josiah", "Anna",	"Lincoln", "Sarah",	"Dylan", "Brooklyn",	"Samuel", "Mackenzie", "John", "Victoria",	"Nathan", "Luna", "Leo", "Penelope", "David", "Grace", "Adam", "Davy"]

  russain_names = ["Абрам", "Александр", "Алексей", "Альберт", "Анатолий", "Андрей", "Антон", "Аркадий", "Арсений", "Артём", "Артур", "Афанасий", "Богдан", "Борис", "Вадим", "Валентин", "Валерий", "Василий", "Вениамин", "Виктор", "Виталий", "Влад", "Владимир", "Владислав", "Всеволод", "Вячеслав", "Гавриил", "Гарри", "Геннадий", "Георгий", "Герасим", "Герман", "Глеб", "Григорий", "Давид", "Даниил", "Денис", "Дмитрий", "Евгений", "Егор", "Ефим", "Захар", "Иван", "Игнат", "eegNAH", "Игорь", "Илларион", "Илья", "Иммануил", "Иосиф", "Кирилл", "Константин", "Лев", "Леонид", "Макар", "Максим", "Марат", "Марк", "Матвей", "Михаил", "Нестор", "Никита", "Николай", "Олег", "Павел", "Пётр", "Роберт", "Родион", "Роман", "Ростислав", "Руслан", "Семён", "Сергей", "Спартак", "Станислав", "Степан", "Тарас", "Тимофей", "Тимур", "Трофим", "Эдуард", "Эрик", "Юлиан", "Юрий", "Яков", "Ярослав"]


  def run_bots_turns()
    if $game.players
      until $game.player_turn == 1
        run_bots
      end
    end
  end

  def run_bots
    bot = $game.player_who_is_playing
    if bot.cards_left == 0
      $game.next_turn
      return
    end
    player = bot
    until player.name != bot.name && player.cards_left > 0
      player = $game.players[rand($game.players.length - 1)]

    end
    hand = bot.player_hand
    card = hand[rand(hand.length - 1)]
    request = Request.new(bot.name, player.name, card.rank_value)
    result = $game.do_turn(request)
    if result == "Go fish"
      $results.push("#{bot.name} asked #{player.name} for a #{card.rank_value} and went fishing")
    elsif result == "you can't ask that"
      $result.push("Clot, #{bot.name} ask for a card he did not have")
    else
      $results.push("#{bot.name} asked #{player.name} for a #{card.rank_value} got the #{result}")
    end
  end

  post('/join') do
    json_obj = JSON.parse(request.body.read)
    $number_of_players = json_obj["number_of_players"].to_i
    $game ||= GofishGame.new
    if $game.players
      $game
    else
      names = []
      numbers_used = []
      names.push(json_obj["name"])
      ($number_of_players - 1).times do
        random_number = rand(russain_names.length)
        name = russain_names.fetch(random_number)
        until name != json_obj["name"]
          numbers_used.each do |number|
            if number == random_number
              random_number = rand(russain_names.length)
            end
          end
          name = russain_names.fetch(random_number)
        end
        numbers_used.push(random_number)
        names.push(russain_names.fetch(random_number))
      end
      $game.start($number_of_players, names)
    end
    hash = {status: 200, message: "Hi #{json_obj["name"]}"}
    json hash
  end

  post('/request_card') do
    json_obj = JSON.parse(request.body.read)
    player_who_asked = $game.player_who_is_playing.name
    if json_obj["desired_rank"] == false
      $game.next_turn
    else
      request = Request.new(player_who_asked, json_obj["player_who_was_asked"], json_obj["desired_rank"])
      result = $game.do_turn(request)
      if result == "Go fish"
        $results.push("#{player_who_asked} asked #{json_obj["player_who_was_asked"]} for a #{json_obj["desired_rank"]} and went fishing")
      elsif result == "you can't ask that"
        $results.push("Clot, #{player_who_asked} ask for a card he did not have")
      else
        $results.push("#{player_who_asked} asked #{json_obj["player_who_was_asked"]} for a #{json_obj["desired_rank"]} got the #{result}")
      end
    end
    run_bots_turns
    if $game.winner != false
      $hash = {result: $game.winner, game_state: game_state}
      $game = nil
      $results = []
    else
      $hash = {result: "no winner yet", game_state: game_state}
    end
    json $hash
  end

  get "/winner" do
    $hash ||=  {result: "no winner yet"}
    json $hash
  end

  get "/game" do
    json game_state
  end

  get "/app" do
    if $game == nil
      hash = {game: false}
    else
      hash = {game: true}
    end
    json hash
  end
  def game_state
    {game: $game, log: $results, cards_left_in_deck: $game.cards_left_in_deck}
  end
end
