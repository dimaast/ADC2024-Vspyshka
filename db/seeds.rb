# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# views/layouts/application чтобы сменить title
# has_many :comments, dependent: :destroy удаляем все связанные комментарии, если удален ивент
# rails db:rollback убрать последнюю миграцию
# bundle install устанавливаем джемы
# rails g uploader Cover создаем аплоадер для обложек ивентов


# Вводим текст
@raw_text = "Дом Наркомфина — один из знаковых памятников архитектуры советского авангарда и конструктивизма. Построен в 1928—1930 годах по проекту архитекторов Моисея Гинзбурга, Игнатия Милиниса и инженера Сергея Прохорова для работников Народного комиссариата финансов СССР (Наркомфина). Автор замысла дома Наркомфина Гинзбург определял его как «опытный дом переходного типа». Дом находится в Москве по адресу: Новинский бульвар, дом 25, корпус 1. С начала 1990-х годов дом находился в аварийном состоянии, был трижды включён в список «100 главных зданий мира, которым грозит уничтожение». В 2017—2020 годах отреставрирован по проекту АБ «Гинзбург Архитектс», функционирует как элитный жилой дом. Отдельно стоящий «Коммунальный блок» (историческое название) планируется как место проведения публичных мероприятий."

# Убираем из текста лишние символы и down-кейсим слова
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

# Функция очистки и наполнения бд через сиды
def seed
  reset_db
  create_events(10)
  # create_users(10)
  # create_faculties
  # create_programs
  # create_communities
  # create_meets(10)
  create_comments(2..8)
end

# Функция очистки бд, которую встраиваем в seed
def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

# Функция генерации предложений
def create_sentence
  # Создаем список предложений
  sentence_words = []

  # Добавляем 10-20 слов из words как один объект списка
  (10..20).to_a.sample.times do
      sentence_words << @words.sample
  end

  # Объединяем строку через пробел, делаем первую букву заглавной и ставим точну в конце
  sentence_words.join(' ').capitalize + '.'
end

# Функция генерации рандомной картинки
def upload_random_image
  uploader = CoverUploader.new(Event.new, :cover)
  uploader.cache!(File.open(Dir.glob(File.join(Rails.root, 'public/autoupload/events', '*')).sample))
  uploader
end

# Функция создания ивентов (quantity раз)
def create_events(quantity)
  quantity.times do |i|
      event = Event.create(
        title: "Ивент №#{i + 1}",
        body: create_sentence,
        cover: upload_random_image,
        hosted_at: DateTime.current.to_date)
      puts "Event with id #{event.id} just created!"
  end
end

# Функция создания комментариев ко всем ивентам (quantity слов в комментарии)
def create_comments(quantity)
  Event.all.each do |event|
      quantity.to_a.sample.times do
          e_comment = Comment.create(
            event_id: event.id,
            body: create_sentence)
          puts "Comment #{e_comment.id} for event #{e_comment.event.id} just created!"
      end
  end
end

seed
