require "./../lib/request"
require "pry"
require "sinatra"
require "sinatra/reloader"
require './../lib/encrypting_and_decrypting'
require "./../lib/game"
require "json"
require "sinatra/json"

class App < Sinatra::Base
  MESSAGE_KEY = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt.random_key
  NUMBER_OF_PLAYERS = 4
  russain_american_names = ["Aleksandr", "Aleksey", "Alex", "Alexander", "Alexandr", "Alexandra", "Alexey", "Alexis", "Alper", "Andrej", "Andrew", "Andrey", "Anton", "Anya", "Artem", "Arthur", "Artur", "Artym", "Artyom", "Aytal", "Baldan", "Borislav", "Collosus", "Dan", "Daniel", "Daniil", "Danilov", "Dave", "Denis", "Dima", "Dmitrii", "Dmitriy", "Dmitry", "Dominique", "Donatien", "Edward", "Fabrice", "Fayad", "Gena", "Gleb", "Grairik", "Grechihckin", "Hamza", "Igor", "Ilushka", "Ilya", "Ivan", "Kirill", "Kirill", "Nikonov", "Kolya", "Konstantin", "Kostya", "Lex", "Max", "Maxim", "Maximka", "Mikhail", "Murad", "Nastya", "Nick", "Nicky", "Nike", "Nikita", "Oleg", "Omer", "Ostin", "Pasha", "Paul", "Pavel", "Pawel", "Philip", "Raoul", "Rodion", "Roma", "Roman", "Ruslan", "Sacha", "Samuele", "Sasha", "Sebastian", "Serge", "Sergei", "Sergey", "Stas", "Thierry", "Tseden", "Uche", "Vadim", "Vadmas", "Valera", "Vanya", "Vasiliy", "Vlad", "Vladimir", "Vladislav", "Vova", "Will", "Yegor", "Yura", "Yuri", "Aigul", "Aleksandra", "Alena", "Alex", "Alexandra", "Alice", "Alina", "Alisa", "Alla", "Alyona", "Anastasia", "Anastasiya", "Ann", "Anna", "Anny", "Anya", "Arina", "Catherine", "Chimita", "Christine", "Daria", "Darya", "Dasha", "Diana", "Dinara", "Ekaterina", "Elena", "Evgenia", "Galina", "Galya", "Gulnaz", "Guzel", "Helen", "Inna", "Irene", "Irina", "Jane", "Julia", "Julie", "Karina", "Kate", "Katerina", "Katia", "Katy", "Katya", "Kristina", "Ksenia", "Kseniya", "Ksusha", "Lana", "Lena", "Lera", "Liliya", "Lina", "Lisa", "Liza", "Luba", "Lyuba", "Margarita", "Maria", "Marie", "Marina", "Mariya", "Mary", "Masha", "Nadya", "Nastia", "Nastya", "Natalia", "Natalie", "Nataly", "Natalya", "Natasha", "Nina", "Oksana", "Olesya", "Olga", "Olya", "Pauline", "Polina", "Regina", "Sasha", "Sofia", "Sonya", "Sveta", "Svetlana", "Tanya", "Tatiana", "Tatyana", "Valentina", "Valeria", "Valerie", "Varya", "Vera", "Veronika", "Victoria", "Vika", "Yana", "Yulia", "Zhanna"]
  array_of_names = ["Sophia", "Jackson", "Olivia", "Liam", "Emma", "Noah", "Ava", "Aiden", "Isabella", "Lucas", "Mia", "Caden", "Aria",	"Grayson", "Riley",	"Mason", "Zoe", "Elijah", "Amelia",	"Logan", "Layla",	"Oliver", "Charlotte",	"Ethan", "Aubrey",	"Jayden", "Lily",	"Muhammad", "Chloe",	"Carter", "Harper",	"Michael", "Evelyn",	"Sebastian", "Adalyn",	"Alexander", "Emily",	"Jacob", "Abigail",	"Benjamin", "Madison",	"James", "Aaliyah",	"Ryan", "Avery",	"Matthew", "Ella",	"Daniel", "Scarlett",	"Jayce", "Maya",	"Mateo", "Mila",	"Caleb", "Nora",	"Luke", "Camilla",	"Julian", "Arianna",	"Jack", "Eliana",	"William", "Hannah",	"Wyatt", "Leah",	"Gabriel", "Ellie",	"Connor", "Kaylee",	"Henry", "Kinsley",	"Isaiah", "Hailey",	"Isaac", "Madelyn",	"Owen", "Paisley",	"Levi", "Elizabeth",	"Cameron", "Addison",	"Nicholas", "Isabelle",	"Josiah", "Anna",	"Lincoln", "Sarah",	"Dylan", "Brooklyn",	"Samuel", "Mackenzie", "John", "Victoria",	"Nathan", "Luna", "Leo", "Penelope", "David", "Grace", "Adam", "Davy"]

  russain_names = ["Абрам™", "Александр™", "Алексей™", "Альберт™", "Анатолий™", "Андрей™", "Антон™", "Аркадий™", "Арсений™", "Артём™", "Артур", "Афанасий", "Богдан", "Борис", "Вадим", "Валентин", "Валерий", "Василий", "Вениамин", "Виктор", "Виталий", "Влад", "Владимир", "Владислав", "Всеволод", "Вячеслав", "Гавриил", "Гарри", "Геннадий", "Георгий", "Герасим", "Герман", "Глеб", "Григорий", "Давид", "Даниил", "Денис", "Дмитрий", "Евгений", "Егор", "Ефим", "Захар", "Иван", "Игнат", "eegNAH", "Игорь", "Илларион", "Илья", "Иммануил", "Иосиф", "Кирилл", "Константин", "Лев", "Леонид", "Макар", "Максим", "Марат", "Марк", "Матвей", "Михаил", "Нестор", "Никита", "Николай", "Олег", "Павел", "Пётр", "Роберт", "Родион", "Роман", "Ростислав", "Руслан", "Семён", "Сергей", "Спартак", "Станислав", "Степан", "Тарас", "Тимофей", "Тимур", "Трофим", "Эдуард", "Эрик", "Юлиан", "Юрий", "Яков", "Ярослав"]
  post('/join') do
    json_obj = JSON.parse(request.body.read)
    number_of_players = json_obj["number_of_players"].to_i
    $game = GofishGame.new
    if $game.players
      $game
    else
      names = []
      numbers_used = []
      (number_of_players - 1).times do
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
      names.push(json_obj["name"])
      $game.start(number_of_players, names)
    end
    hash = {status: 200, message: "Hi #{json_obj["name"]}"}
    json hash
  end

  get "/game" do
    game = {game: $game}
    json game
  end
end
