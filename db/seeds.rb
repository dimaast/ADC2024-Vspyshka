# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Полезные штуки
# views/layouts/application чтобы сменить title
# has_many :comments, dependent: :destroy удаляем все связанные комментарии, если удален ивент

# Связи
# valifdates :username, presence: true, uniqueness: true
# optional :true если может не принадлежать
# .all все сущности
# .where(attribute_id: 1) сущности где айди атрибута равно 1
# <%= link_to faculty do %>
# <%= render faculty, faculty: faculty %>
# <% end %>
# если в views/layouts создать html.erb с названием модели, у нее будет свой лэйаут, в который можно вывести что-то свое. в контролере можно распределить лэйауты layout "application", only: %i[ show new edit create update destroy ]


# Создание веб-сервиса
# terminal          | создать проект                           | rails new ProjectName
# terminal          | открыть сервер                           | rails s
# terminal          | закрыть сервер                           | ctrl + c


# Работа с моделью
# terminal          | создать все для модели                   | rails g scaffold Model attribute_1:string attribute_2:references
# terminal          | создать модель                           | rails g model Model body:text publication:references
# terminal          | создать контроллер и вьюс                | rails g controller welcome/about
# terminal          | добавить аттрибут в модель               | rails g migration add_attribute_to_models attribute:string
# terminal          | запускаем миграции                       | rails db:migrate
# terminal          | отменить последнюю миграцию              | rails db:rollback
# write code        | models/event: запускаем валидацию        | validates :title, presence: true, length: { minimum: 5 }


# Работа с роутами
# write code        | routes: меняем главную                   | root "welcome#index"
# write code        | routes: забираем данные контроллера      | get "welcome/index"
# write code        | routes: забираем данные контроллера      | get "welcome/about"
# write code        | routes: вкладываем путь                  | resources :publications do resources :comments end


# Работа с контроллером
# write code        | controller                               | current_user.events (ивенты только пользователя)


# Работа с вью
# write code        | model/form выбор коллекции селектор      | <%= form.collection_select :project_id, current_user.projects.order(:name), :id, :name, include_blank: true %>


# Создание изображений
# write code        | gemfile                                  | gem "carrierwave", "~> 3.0"
# terminal          | установить gem                           | bundle install
# create            | folder                                   | public/autoupload/models
# write code        | gitignore                                | /public/uploads
# write code        | gitignore                                | /public/autoupload
# terminal          | создаем поле                             | rails g migration add_event_cover_to_events event_cover:string
# terminal          | создаем поле                             | rails db:migrate
# terminal          | создаем аплоадер                         | rails g uploader EventCover
# write code        | models/event                             | mount_uploader :event_cover, EventCoverUploader
# write code        | event partial                            | <%= image_tag event.event_image.url, width: 600 if event.cover.present? %>
# write code        | event form                               | <%= form.label :event_cover, style: "display: block" %>
# write code        | event form                               | <%= form.file_field :event_cover %>
# write code        | controllers/event                        | :event_cover (в параметры для приема)


# Создаем юзеров
# write code        | gemfile                                  | gem "devise"
# terminal          | установить gem                           | bundle install
# terminal          | установить gem                           | rails g devise:install
# terminal          | создаем модель                           | rails g devise Model
# terminal          | запускаем миграции                       | rails db:migrate
# write code        | controller                               | def create @event = current_user.events.new(event_params) (прикрепряет юзера к новому ивенту)
# write code        | controller                               | before_action :authenticate_user! (фильтр/экшн коллбек, который запрашивает вход юзера)


# Восстанавливаем пароль
# write code        | gemfile group :development               | gem "letter_opener" (для проверки писем на почту при восстановлении пароля)
# terminal          | установить gem                           | bundle install
# write code        | config/environments/development.rb       | config.action_mailer.delivery_method = :letter_opener
# write code        | config/environments/development.rb       | config.action_mailer.perform_deliveries = true


# Аутентификация (вход — проверка личности) и авторизация (проверка доступов у личности)
# write code        | gemfile                                  | gem "cancancan"
# terminal          | установить gem                           | bundle install
# terminal          | создать cancan                           | rails g cancan:ability
# write code        | models/ability.rb                        | can [ :read, :archive ], Event (можно смотреть index, archive и их show)
# write code        | models/ability.rb                        | can :manage, Event, user: user (можно редактировать show, которые принадлежат юзеру)
# write code        | models/ability.rb                        | can :read, Community, user: user (можно смотреть index и show, которые принадлежат юзеру)
# write code        | models/ability.rb                        | can :read, Community (можно смотреть index и show)
# write code        | models/ability.rb                        | can :read, Event, user: 2 (можно смотреть index и show только у юзера с id 2)
# load_and_authorize_resource для cancancan


# Создаем дополнительный вью/контроллер/etc для админа (существует вид для пользователя и для админа)
# create            | folder                                   | controllers/admin
# create            | file                                     | controllers/admin/models_controller.rb
# write code        | дублировать код из не admin              | class - end
# write code        | редактировать название контроллера       | class Admin::ModelsController < ApplicationController
# write code        | routes: создать namespace                | namespace :admin do resources :communities, only: [:index]
# write code        | _header: создать линк на админскую       | <% if user_signed_in? && current_user.role == "admin" %>?
# create            | folder                                   | views/admin
# create            | file                                     | views/admin/index.html.erb
# <%= link_to faculty.name, admin_faculty_path(faculty) %>
# index: <%= link_to "New faculty", new_admin_faculty_path %>
# application_controller: https://github.com/CanCanCommunity/cancancan/blob/develop/docs/handling_access_denied.md
# admin_faculty_path(@program.faculty)
# admin_program_path(@program)


# Отдаем часть вью/контроллер/etc админу (доступно только админу)
# write code        | views: изменить path                     | partial/index/form/edit/new/show
# write code        | controller: изменить path                | create/update/destroy


# Редирект вместо ошибки CanCanCan
# write code        | application_controller                   | rescue_from CanCan::AccessDenied do |exception|


# Запрещаем редактировать только какое-то поле
# можно сделать две формы — для пользователя и для админа, но этого мало
# в контроллере НЕ админа надо запретить принимать параметр


# Условия
# <% if current_user && current_user.role == "admin" %> если юзер зашел и его роль админ
# <% if can? :destroy, @community %> если ability дает destroy


# Работа с папками файлов для css
# Rails.application.config.assets.paths << "app/assets'fonts" в config/initializers/assets.rb


# Собираем почты
# rails g scaffold EmailSubscription email:string
# rails db:migrate
# models/email_subscription: validates :email, presence: true
# view/email_subsctiption/_form: model: EmailSubscroption.build email_field: email
# welcome/index: создаем div с id email_subscription_form
# welcome/index: вкладываем в div <%= render "email_subscriptions/form" %>
# routes: resources :email_subscriptions, only: [ :create ]
# view/email_subsctiption: создаем файл _success с сообщением p
# view/email_subsctiption: создаем файл show.turbo_stream.erb
# view/email_subsctiption/show.turbo_stream.erb: пишем <%= turbo_stream.replace "email_subscription_form", partial: "success" %>
# email_subscriptions_controller: в def create if subscription.save format.turbo_stream { render :show }
# abilities: can :create EmailSubscription


# Смотрим почты (только админ)
# welcome/index: <% if current_user && current_user.role == "admin" %>
# welcome/index: link_to "Подписка на рассылку", admin_email_subscriptions_url
# routes/admin: resources email_subscriptions
# controller/admin: create email_subscriptions_controller.rb
# admin/email_subscriptions_controller: add code favourite scaffold delete json


# Создаем API
# terminal          | создаем контроллер для модели            | rails g controller api/v1/events
# write code        | controller/api/v1/events                 | def index (копируем из обычного)
# write code        | config/routes                            | namespace :api, format: json do namespace :v1 do resources :events, only: [:index, :show]
# write code        | # views/welcome/index                      | <%= api_v1_events_url %> / <%= api_v1_events_path %>
# write code        | # controller/api/v1/events def index     | render json: @events.as_json
# note              | # ограничить вывод полей                 | .as_json(except: :title) or .as_json(only: :title)
# write code        | # models/event                           | def as_json { title: title }
# change folder     | из views/events в views/api/v1/events    | все json.jbuilder файлы
# write code        | views/api/v1/events/index.json.jbuilder  | partial: "api/v1/events/event"
# write code        | views/api/v1/events/_event.json.jbuilder | json.url event_url(event)
# write code        | controller/api/v1/events def show        | @event = Event.find(params[:id])
# write code        | views/api/v1/events/show.json.jbuilder   | partial: "api/v1/events/event"


# API комментариев к ивентам
# change folder     | views/api/v1/events/                     | views/comments/_comment.json.jbuilder
# write code        | views/api/v1/events/show.json.jbuilder   | json.set! :comments do json.array! @event.comments, partial: "api/v1/events/comment", as: :comment end


# API изображения к ивентам (как выводить нормальную ссылку)
# write code        | views/api/v1/events/_event.json.jbuilder | проверить параметр cover
# write code        | model/uploaders/event_uploaders_cover    | def asset_host return "http://localhost:3000" end


# Разблокировать get и publication запросы с других источников (например приложение)
# write code        | gemfile                                  | gem "rack-cors"
# terminal          | установить gem                           | bundle install
# create folder     | config/initializers                      | cors.rb
# write code        | cors.rb                                  | Rails.application.config.middleware.insert_before 0, Rack::Cors do
#                                                                  allow do
#                                                                    origins 'http://localhost:3000/'
#                                                                    resource '*', headers: :any, methods: [:get, :publication]
#                                                                  end
#                                                                end

# Автоматическое возникновение профиля после юзера
# terminal          | создаем Profile                          | rails g scaffold Profile name:string body:text contact:string avatar:string user:references
# terminal          | запускаем миграции                       | rails db:migrate
# write code        | пишем ассоциации в models/user           | has_one
# write code        | пишем ассоциации в models/profile        | belongs_to
# write code        | пишем after_create в models/user         | after_create :create_profile (можно еще after_create :create_user_profile private def create_user_profile with self.create_profile())


# Делаем автоджоин (комментарии, отвечающие на комментарии)
# rails g migration add_comment_id_to_comment comment_id:integer
# rails db:migrate
# has_many :replies, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy
# belongs_to :comment, optional: true
# def create_comment_replies Comment.all.shuffle.last(30).each do |comment| user = User.all.sample comment_reply = comment.replies.create( event_id: comment.event_id, body: create_sentence, user_id: user.id) puts "Reply #{comment_reply.id} for event #{comment_reply.event.id} just created!" end end
# rails db:seed
# model/comment: scope :no_replies, -> { where(comment_id: nil) }
# events/show: @event.comments.no_replies.each
# views/comments/_comment: <div class="<%= "M_Reply" if comment.comment_id != nil %>" id="<%= dom_id comment %>">
# views/comments/_comment: <% if comment.replies.any? %> <%= render comment.replies, partial: "comments/comment", as: :comment %> <% end %>
# views/events/show: <% if user_signed_in? %> <h2>Добавить комментарий:</h2> <%= render "comments/form", comment: Comment.new, event: @event %> <% end %>
# comments_controller: params.require(:comment).permit(:body, :comment_id).merge(event_id: params[:event_id])
# model/comment: default_scope { order(created_at: "DESC") }
# views/comments/_comment: <% if user_signed_in? %> <%= render partial: "comments/form", locals: { comment: Comment.new, event: comment.event, parent_comment_id: comment.id } %> <% end %>
# views/comments/_form: <% if defined? parent_comment_id %> <%= form.hidden_field :comment_id, value: parent_comment_id %> <% end %>


# Полиморфные связи
# terminal          | создаем модель favourite                 | rails g model favourite favouriteable_type:string favouriteable_id:integer user:references
# terminal          | запускаем миграции                       | rails db:migrate
# write code        | model/favourite                          | belongs_to :user
# write code        | model/favourite                          | belongs_to :favouriteable, polymorphic: true
# write code        | model/event                              | has_many :favourites, as: :favouriteable
# write code        | model/meet                               | has_many :favourites, as: :favouriteable
# write code        | model/comment                            | has_many :favourites, as: :favouriteable
# terminal          | создаем контроллер favourite             | rails g controller favourite toggle
# write code        | # routes: меняет get на publication      | publication "favourite/toggle"
# change folder     | переименовываем views/favourite/toggle   | views/favourite/_button
# write code        | views/events/_button                     | <%= favourite = favouriteable.favourites.where(user_id: current_user.id) button_text = favourite && favourite.count > 0 ? "Unfavourite" : "favourite" %> <div><%= link_to "Нравится", favourite_toggle_path(type: favouriteable.class, id: favouriteable.id), data: { turbo_stream: true }  %></div>
# write code        | views/events/show                        | <%= render partial: "favourite/button", locals: { favouriteable: @event } %> (если в паршл, будет a в a)
# write code        | views/meets/show                         | <%= render partial: "favourite/button", locals: { favouriteable: @meet } %>
# write code        | views/comments/_comment                  | <%= render partial: "favourite/button", locals: { favouriteable: comment } %>
# write code        | controllers/favourite_controller         | def toggle favouriteable = Object.const_get(params[:type]).find(params[:id]) favourites = favouriteable.favourites.where(user_id: current_user.id) if favourites && favourites.count > 0 favourites.each do |favourite| favourite.destroy! end else current_user.favourites.create!(favouriteable_type: params[:type], favouriteable_id: params[:id]) end

# favouriteable_type — тип объекта
# favouriteable_id — сам объект внутри типа

# Меняем комментарии с обычных на полиморфные
# rails g migration  add_commentable_type_to_comment commentable_type:string
# rails g migration  add_commentable_id_to_comment commentable_id:integer
# rails generate migration RemoveEventIdFromComments event_id:integer


# Теги
# write code        | gemfile                                  | gem "acts-as-taggable-on"
# terminal          | установить gem                           | bundle install
# terminal          | установить gem                           | rake acts_as_taggable_on_engine:install:migrations
# terminal          | установить gem                           | rake db:migrate
# write code        | model/event                              | acts_as_taggable_on :tags
# write code        | controllers/event_controller             | в permit: :tag_list
# write code        | views/events/_form                       | <div><%= label for="">Tags</label><%= form.text_area :tag_list %></div>
# write code        | routes                                   | get "/by_tag/:tag", to "events#by_tag", on: :collection, as: "tagged"
# write code        | views/events/_event                      | <p><% event.tags.each do |tag| %> <%= link_to tag.name, tagged_events_path(tag.name) %> </p>
# write code        | views/events/index                       | <div><%= link_to "All", events_path %> <% Event.tag_counts_on(:tags).each do |tag| %> <%= link_to tag.name, tagged_events_path(tag.name) %> </div>
# write code        | controllers/event_controller             | def by_tag @events = Event.tagged_with(params[:tag]) render :index end

# Добавляем категории
# write code        | model/event                              | acts_as_taggable_on :categories
# write code        | views/events/_form                       | <div><%= label for="">Категории</label><%= form.text_area :category_list %></div>
# write code        | controllers/event_controller             | в permit: :category_list
# write code        | controllers/event_controller             | def by_category @events = Event.tagged_with(params[:tag]) render :index end
# write code        | views/events/_event                      | <p><% event.category.each do |tag| %> <%= link_to tag.name, tagged_events_path(tag.name) %> </p>
# write code        | views/events/index                       | <div><%= link_to "All", events_path %> <% Event.tag_counts_on(:categories).each do |tag| %> <%= link_to tag.name, tagged_events_path(tag.name) %> </div>

# STI (разные типы постов)
# rails g scaffold Publication type:string title:string body:text embed:text
# rails g model PublicationText --parent=Publication
# rails g model PublicationText --parent=Publication
# rails db:migrate
# controllers/publicationtexts_controller + Publication = PublicationText
# controllers/publicationfigmas_controller + Publication = PublicationFigma
# publications/_form: <%= form.label :type, style: "display: block" %> <%= form.select :type, [["Текстовая публикация", "PublicationText"], ["Фигма-публикация", "PublicationFigma"]] %>
# views/publication_texts/_publication_text: сюда копируем паршл, но меняем publication на publication_text
# views/publication_texts/_publication_text: <%= link_to "Покажи публикацию", publication_path(publication_text) %>
# views/publication_figmas/_publication_figma: сюда копируем паршл, но меняем publication на publication_figma и к ebmed.html_safe
# views/publication_figmas/_publication_figma: <%= link_to "Покажи публикацию", publication_path(publication_figma) %>
# views/publications/_form: url: url
# views/publications/new: в форму url: publications_path
# views/publications/edit: в форму url: publication_path(@publication)
# views/publications/edit: в show publication_path(@publication)

# Views для Devise (страницы логина и регистрации)
# terminal          | установить gem                           | rails g devise:views
# sessions — вход, passwords — смена пароля, registrations — регистрация, shared — все ссылки

# SASS для RoR
# write code        | gemfile                                  | gem "sassc"
# terminal          | установить gem                           | bundle install
# config/initializers/assets.rb  можно написать отдельный css для лендинга

# Работа с yield
# где-то content_for :something do end
# application yield :something

# Метатеги
# write code        | gemfile                                  | gem "meta-tags"
# terminal          | установить gem                           | bundle install
# terminal          | установить gem                           | rails generate meta_tags:install
# write code        | views/layouts/application                | <%= display_meta_tags site: @title ||= "Вспышка", separator: " — ", reverse: true %>
# write code        | views (show/index/edit)                  | <% set_meta_tags( title: "События", description: "Все события Вышки для студентов и работников университета", keywords: "События, Мероприятия, Ивенты, Тусовки, Вышка, НИУ ВШЭ, ВШЭ")%>

# Настройки carriervawe (загрузки изображений от пользователей)
# brew install vips
# brew install jpegoptim
# brew install optipng
# brew install pngquant
# uploaders: include CarrierWave::Vips
# uploaders: def extension_allowlist %w[jpg jpeg gif png] end
# uploaders: def filename "#{secure_token(10).#{file.extension}}" if original_filename end
# uploaders: version :thumb do process resize_to_fit: [50, 50] end
# views/events/_event:  <%= image_tag event.cover.thumb.url if event.cover.present? %>
# uploaders: include CarrierWave::ImageOptimizer
# gemfile: gem "carrierwave-imageoptimizer"
# bundle install
# uploaders: version :q70 do process optimize: [ { quality: 70 } ] end

# Настраиваем русский язык
# gemdfile: gem "russian"
# config/application.rb: config.i18n.default_locale = :ru
# app/views/events/archive.html.erb: Архив событий (<%= @events.count %> <%= Russian.p(@events.count, "событие", "события", "событий") %>)
# config/locales: ru.yml
# config/locales/ru.yml: ru: hello: "Всем привет!"
# app/views/welcome/index.html.erb: <%= t :hello %>

# Турбофреймы (авторедактирование)
# app/views/comments/_comment.html.erb: <%= turbo_frame_tag dom_id(comment) do %> <% end %>
# app/controllers/comments_controller.rb: def edit @event = @comment.event
# app/views/comments/edit.html.erb: <%= turbo_frame_tag dom_id(@comment) do %> <%= render "form", comment: @comment %> <% end %>
# app/controllers/comments_controller.rb: def update redirect_to @comment.event

# Турбостримы (автозамена)
# создаем какой-то div с id mur (например)
# кладем в него <%= render "mur" %>
# создаем _mur.html.erb
# кладем в него <%= "Слово" =%> или, если задали в контроллере @slovo, его
# пишем <%= link_to "Ссылка на кнопку/страницу", folder_mur_path, data: { turbo_stream: true } %>
# создаем _mur.turbo_stream.erb
# кладем туда <#= turbo_stream.replace "mur", partial: "mur" %>

# Турбострим + турбофрейм (создаение нового поста на странице индекс, а не по ссылке)
# app/views/meets/index.html.erb: <%= link_to "New meet", new_meet_path, id: "new_meet_link", data { turbo_stream: true } %>
# создаем файл new.turbo_stream.erb
# кладем туда <#= turbo_stream.replace "new_meet_link", partial: "meets/form", locals: { meet: @meet } %>
# app/views/meets/_form.html.erb: <%= form_with(model: meet, data: { turbo_stream: true }, id: "meet_form") do |form| %>
# создаем файл show.turbo_stream.erb
# кладем туда <#= turbo_stream.replace "meet_form" do %> <%= link_to "New meet", new_meet_path, id: "new_meet_link", data { turbo_stream: true } %> <% end %>
# кладем туда <#= turbo_stream.prepend "C_EventsAndMeets", partial: "meets/meet", locals: { meet: @meet } %>
# возможно надо убрать link_to
# app/views/meets/index.html.erb: <div id="meet_index_heading"><h1>Встречи (<%= @meets.count %>)</h1> </div%>
# show.turbo_stream.erb: <% @meets = Meet.all %> <div id="meet_index_heading"><h1>Встречи (<%= @meets.count %>)</h1> </div%>

# Турбо-комментарии (автообновление)
# пересмотреть и задать квесчены

# Отправляем почту (мейлер)
# rails g mailer User
# app/mailers/user_mailer.rb: https://guides.rubyonrails.org/action_mailer_basics.html#edit-the-mailer
# app/views/user_mailer: два файла welcome_email.html.erb и welcome_email.text.erb
# в них добавляем код и текст: https://guides.rubyonrails.org/action_mailer_basics.html#create-a-mailer-view
# if current_user.events.count == 1 UserMailer.with(user: current_user).welcome_email.deliver_now end

# Сессия
# <%= session.to_json %> сессия хранится на сервере
# <%= cookies.to_json %> куки хранятся в браузере, на ios кук нет(

# API на запись (JTI токены)
# rails g migration add_jti_to_users jti:string
# в миграции , null: false add_index :users, :jti, unique: true
# rails db:migrate
# для юзер сидов добавляем jti:

# Вводим текст
@raw_text = "Дом Наркомфина — один из знаковых памятников архитектуры советского авангарда и конструктивизма. Построен в 1928—1930 годах по проекту архитекторов Моисея Гинзбурга, Игнатия Милиниса и инженера Сергея Прохорова для работников Народного комиссариата финансов СССР (Наркомфина). Автор замысла дома Наркомфина Гинзбург определял его как «опытный дом переходного типа». Дом находится в Москве по адресу: Новинский бульвар, дом 25, корпус 1. С начала 1990-х годов дом находился в аварийном состоянии, был трижды включён в список «100 главных зданий мира, которым грозит уничтожение». В 2017—2020 годах отреставрирован по проекту АБ «Гинзбург Архитектс», функционирует как элитный жилой дом. Отдельно стоящий «Коммунальный блок» (историческое название) планируется как место проведения публичных мероприятий."

# Убираем из текста лишние символы и down-кейсим слова
@words = @raw_text.downcase.gsub(/[—.—,«»:()]/, '').gsub(/  /, ' ').split(' ')

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
def upload_event_cover_image
  uploader = CoverUploader.new(Event.new, :cover)
  uploader.cache!(File.open(Dir.glob(File.join(Rails.root, 'public/autoupload/events', '*')).sample))
  uploader
end

# Функция генерации рандомной обложки Сообщества
def upload_community_cover_image
  uploader = CommunityCoverUploader.new(Community.new, :cover)
  uploader.cache!(File.open(Dir.glob(File.join(Rails.root, 'public/autoupload/communities', '*')).sample))
  uploader
end

# Список сообществ
@communities = [
    {
        title: 'Центр лидерства и волонтёрства',
        user_id: 1,
        cover: upload_community_cover_image,
        contact: 'https://vk.com/hse_volunteers ',
        body: 'Волонтёрский центр Вышки – это команда инициативных и неравнодушных студентов, выпускников и сотрудников университета. Мы помогаем с организацией самых крупных вышкинских проектов: развлекательных и научных. Участвуем в городских фестивалях и конференциях. А ещё помогаем старшему поколению онлайн изучать иностранные языки и школьникам из Москвы и регионов не отставать по школьным предметам.'
    },
    {
        title: 'Студенческий совет НИУ ВШЭ',
        user_id: 1,
        cover: upload_community_cover_image,
        contact: 'https://vk.com/hsecouncil',
        body: 'Студсовет Вышки'
    },
    {
        title: 'HSE Outreach',
        user_id: 1,
        cover: upload_community_cover_image,
        contact: 'https://vk.com/hseoutreach',
        body: 'HSE Outreach — старейшая и одна из крупнейших благотворительных организаций в Вышке.'
    },
    {
        title: 'Экологический клуб “Зелёная Вышка”',
        user_id: 1,
        cover: upload_community_cover_image,
        contact: 'https://vk.com/hsegreen',
        body: 'Экологический клуб'
    },
    {
        title: 'Спортивный клуб',
        user_id: 1,
        cover: upload_community_cover_image,
        contact: 'https://vk.com/hsessc',
        body: 'Спорт для нас — не только здоровый образ жизни. Это люди, традиции и гордость нашего университета.'
    },
    {
        title: 'InsideOut',
        user_id: 1,
        cover: upload_community_cover_image,
        contact: 'https://vk.com/insideout_hse',
        body: 'InsideOut – студенческая организация, выворачивающая «наизнанку» стереотипы об однообразной жизни студентов факультета Мировой Экономики и Мировой Политики. '
    },
    {
        title: 'Клуб вьетнамской культуры',
        user_id: 1,
        cover: upload_community_cover_image,
        contact: 'https://vk.com/vietnamculturehse',
        body: 'Xin chào! Мы – клуб вьетнамской культуры ВШЭ, сообщество энтузиастов, исследующих жизнь Вьетнама'
    }
]

# Список факультетов
@faculties = [
    { name: 'Факультет креативных индустрий (Faculty of Creative Industries)',
      programs: [
        { name: 'Дизайн', faculty_id: 1 },
        { name: 'Реклама и связи с общественностью', faculty_id: 1 },
        { name: 'Медиакоммуникации', faculty_id: 1 },
        { name: 'Журналистика', faculty_id: 1 },
        { name: 'Мода', faculty_id: 1 },
        { name: 'Современное искусство', faculty_id: 1 },
        { name: 'Стратегия и продюсирование в коммуникациях', faculty_id: 1 },
        { name: 'Коммуникационный и цифровой дизайн', faculty_id: 1 },
        { name: 'Кинопроизводство', faculty_id: 1 },
        { name: 'Управление в креативных индустриях', faculty_id: 1 },
        { name: 'Управление стратегическими коммуникациями', faculty_id: 1 },
        { name: 'Интегрированные коммуникации', faculty_id: 1 },
        { name: 'Трансмедийное производство в цифровых индустриях', faculty_id: 1 },
        { name: 'Современная журналистика', faculty_id: 1 },
        { name: 'Медиаменеджмент', faculty_id: 1 },
        { name: 'Практики современного искусства', faculty_id: 1 },
        { name: 'Программа двух дипломов НИУ ВШЭ и ДГТУ "Нейромедиа"', faculty_id: 1 },
        { name: 'Актер', faculty_id: 1 },
        { name: 'Коммуникации в государственных структурах и НКО', faculty_id: 1 },
        { name: 'Коммуникации, основанные на данных', faculty_id: 1 },
        { name: 'Практики кураторства в современном искусстве', faculty_id: 1 },
        { name: 'Критические медиаисследования', faculty_id: 1 },
        { name: 'Дизайн среды', faculty_id: 1 },
        { name: 'Современные технологии преподавания дизайна и искусства', faculty_id: 1 },
        { name: 'Современный дизайн в преподавании изобразительного искусства и технологии в школе', faculty_id: 1 }
      ]
    },
    { name: 'Высшая школа бизнеса (Graduate School of Business)',
      programs: [
        { name: 'Управление бизнесом', faculty_id: 2 },
        { name: 'Бизнес-информатика', faculty_id: 2 },
        { name: 'Маркетинг и рыночная аналитика', faculty_id: 2 },
        { name: 'Управление цифровым продуктом', faculty_id: 2 },
        { name: 'Маркетинг: цифровые технологии и маркетинговые коммуникации', faculty_id: 2 },
        { name: 'Международный бизнес', faculty_id: 2 },
        { name: 'Цифровые инновации в управлении предприятием', faculty_id: 2 },
        { name: 'Бизнес-информатика: цифровое предприятие и управление информационными системами', faculty_id: 2 },
        { name: 'Управление цепями поставок и бизнес-аналитика', faculty_id: 2 },
        { name: 'Маркетинг - менеджмент', faculty_id: 2 },
        { name: 'Стратегический менеджмент и консалтинг', faculty_id: 2 },
        { name: 'Бизнес-аналитика и системы больших данных', faculty_id: 2 },
        { name: 'Международный менеджмент', faculty_id: 2 },
        { name: 'Электронный бизнес и цифровые инновации', faculty_id: 2 },
        { name: 'Производственные системы и операционная эффективность', faculty_id: 2 },
        { name: 'Управление логистикой и цепями поставок в бизнесе', faculty_id: 2 },
        { name: 'Международный спортивный менеджмент, маркетинг и право', faculty_id: 2 },
        { name: 'Менеджмент в ритейле', faculty_id: 2 },
        { name: 'Логистика и управление цепями поставок', faculty_id: 2 },
        { name: 'Управление исследованиями, разработками и инновациями в компании', faculty_id: 2 },
        { name: 'Юрист мирового финансового рынка', faculty_id: 2 },
        { name: 'Стратегическое управление логистикой и цепями поставок в цифровой экономике', faculty_id: 2 },
        { name: 'Управление инвестиционными проектами', faculty_id: 2 },
        { name: 'Управление людьми: цифровые технологии и организационное развитие', faculty_id: 2 },
        { name: 'Управление устойчивым развитием компании', faculty_id: 2 },
        { name: 'Международный корпоративный комплаенс и этика бизнеса', faculty_id: 2 },
        { name: 'Церковь, общество и государство. Правовое регулирование деятельности религиозных объединений', faculty_id: 2 },
        { name: 'Государственно-конфессиональные отношения. Правовое регулирование деятельности религиозных объединений', faculty_id: 2 }
      ]
    },
    { name: 'Факультет социальных наук (Faculty of Social Sciences)',
      programs: [
        { name: 'Психология', faculty_id: 3 },
        { name: 'Государственное и муниципальное управление', faculty_id: 3 },
        { name: 'Социология', faculty_id: 3 },
        { name: 'Психоанализ и психоаналитическое бизнес-консультирование', faculty_id: 3 },
        { name: 'Психоанализ и психоаналитическая психотерапия', faculty_id: 3 },
        { name: 'Политология', faculty_id: 3 },
        { name: 'Управление образованием', faculty_id: 3 },
        { name: 'Психология в бизнесе', faculty_id: 3 },
        { name: 'Консультативная психология. Персонология', faculty_id: 3 },
        { name: 'Управление в высшем образовании', faculty_id: 3 },
        { name: 'Управление в сфере науки, технологий и инноваций', faculty_id: 3 },
        { name: 'Управление и экономика здравоохранения', faculty_id: 3 },
        { name: 'Педагогическое образование', faculty_id: 3 },
        { name: 'Политика. Экономика. Философия', faculty_id: 3 },
        { name: 'Обучение и оценивание как наука', faculty_id: 3 },
        { name: 'Социология публичной сферы и цифровая аналитика', faculty_id: 3 },
        { name: 'Прикладная социальная психология', faculty_id: 3 },
        { name: 'Доказательное развитие образования', faculty_id: 3 },
        { name: 'Когнитивные науки и технологии: от нейрона к познанию', faculty_id: 3 },
        { name: 'Вычислительные социальные науки', faculty_id: 3 },
        { name: 'Прикладная политология', faculty_id: 3 },
        { name: 'Современные социальные науки в преподавании обществознания в школе', faculty_id: 3 },
        { name: 'Прикладные методы социального анализа рынков', faculty_id: 3 },
        { name: 'Системная семейная психотерапия', faculty_id: 3 },
        { name: 'Позитивная психология', faculty_id: 3 },
        { name: 'Сравнительные социальные исследования', faculty_id: 3 },
        { name: 'Население и развитие', faculty_id: 3 },
        { name: 'Комплексный социальный анализ', faculty_id: 3 },
        { name: 'Демография', faculty_id: 3 },
        { name: 'Прикладная статистика с методами сетевого анализа', faculty_id: 3 },
        { name: 'Цифровая трансформация образования', faculty_id: 3 },
        { name: 'Педагогичеcкая деятельность в условиях изменений', faculty_id: 3 },
        { name: 'Социология публичной и деловой сферы', faculty_id: 3 },
        { name: 'Управление низкоуглеродным развитием', faculty_id: 3 },
        { name: 'Политический анализ и публичная политика', faculty_id: 3 },
        { name: 'Филологическая герменевтика школьной словесности', faculty_id: 3 }
      ]
    },
    { name: 'Факультет компьютерных наук (Faculty of Computer Science)',
      programs: [
        { name: 'Прикладная математика и информатика', faculty_id: 4 },
        { name: 'Программная инженерия', faculty_id: 4 },
        { name: 'Прикладной анализ данных', faculty_id: 4 },
        { name: 'Магистр по наукам о данных', faculty_id: 4 },
        { name: 'Машинное обучение и высоконагруженные системы', faculty_id: 4 },
        { name: 'Экономика и анализ данных', faculty_id: 4 },
        { name: 'Науки о данных', faculty_id: 4 },
        { name: 'Компьютерные науки и анализ данных', faculty_id: 4 },
        { name: 'Финансовые технологии и анализ данных', faculty_id: 4 },
        { name: 'Современные компьютерные науки', faculty_id: 4 },
        { name: 'Анализ данных в биологии и медицине', faculty_id: 4 },
        { name: 'Системная и программная инженерия', faculty_id: 4 },
        { name: 'Математика машинного обучения', faculty_id: 4 },
        { name: 'Системное программирование', faculty_id: 4 },
        { name: 'Анализ данных в девелопменте', faculty_id: 4 }
      ]
    },
    { name: 'Факультет экономических наук (Faculty of Economic Sciences)',
      programs: [
        { name: 'Экономика', faculty_id: 5 },
        { name: 'Экономика и статистика', faculty_id: 5 },
        { name: 'Совместная программа по экономике НИУ ВШЭ и РЭШ', faculty_id: 5 },
        { name: 'Экономика и экономическая политика', faculty_id: 5 },
        { name: 'Корпоративные финансы', faculty_id: 5 },
        { name: 'Стратегическое управление финансами фирмы', faculty_id: 5 },
        { name: 'Экономический анализ', faculty_id: 5 },
        { name: 'Экономика и анализ данных', faculty_id: 5 },
        { name: 'Финансовый инжиниринг', faculty_id: 5 },
        { name: 'Финансовые рынки и финансовые институты', faculty_id: 5 },
        { name: 'Магистр аналитики бизнеса', faculty_id: 5 },
        { name: 'Инвестиции на финансовых рынках', faculty_id: 5 },
        { name: 'Международная торговая политика', faculty_id: 5 },
        { name: 'Финансы', faculty_id: 5 },
        { name: 'Финансовый аналитик', faculty_id: 5 },
        { name: 'Стохастическое моделирование в экономике и финансах', faculty_id: 5 },
        { name: 'Статистический анализ в экономике', faculty_id: 5 },
        { name: 'Аналитик деловой разведки', faculty_id: 5 },
        { name: 'Совместная программа бакалавриата по экономике НИУ ВШЭ и ДВФУ', faculty_id: 5 },
        { name: 'Аграрная экономика', faculty_id: 5 }
      ]
    },
    { name: 'Факультет мировой экономики и мировой политики (Faculty of World Economy and International Affairs)',
      programs: [
        { name: 'Востоковедение', faculty_id: 6 },
        { name: 'Мировая экономика', faculty_id: 6 },
        { name: 'Программа двух дипломов НИУ ВШЭ и Университета Кёнхи "Экономика и политика в Азии"', faculty_id: 6 },
        { name: 'Международные отношения', faculty_id: 6 },
        { name: 'Международная программа "Международные отношения и глобальные исследования"', faculty_id: 6 },
        { name: 'Международные отношения: европейские и азиатские исследования', faculty_id: 6 },
        { name: 'Социально-экономическое и политическое развитие современной Азии', faculty_id: 6 },
        { name: 'Программа двух дипломов НИУ ВШЭ и Университета Кёнхи "Экономика, политика и бизнес в Азии"', faculty_id: 6 },
        { name: 'Экономика окружающей среды и устойчивое развитие', faculty_id: 6 }
      ]
    },
    { name: 'Факультет гуманитарных наук (Faculty of Humanities)',
      programs: [
        { name: 'Филология', faculty_id: 7 },
        { name: 'История', faculty_id: 7 },
        { name: 'Фундаментальная и компьютерная лингвистика', faculty_id: 7 },
        { name: 'Философия', faculty_id: 7 },
        { name: 'Культурология', faculty_id: 7 },
        { name: 'История искусств', faculty_id: 7 },
        { name: 'Античность', faculty_id: 7 },
        { name: 'Культурные исследования', faculty_id: 7 },
        { name: 'Литературное мастерство', faculty_id: 7 },
        { name: 'Современная историческая наука в преподавании истории в школе', faculty_id: 7 },
        { name: 'Компьютерная лингвистика', faculty_id: 7 },
        { name: 'История художественной культуры и рынок искусства', faculty_id: 7 },
        { name: 'Философская антропология', faculty_id: 7 },
        { name: 'Русский как иностранный во взаимодействии языков и культур', faculty_id: 7 },
        { name: 'Цифровые методы в гуманитарных науках', faculty_id: 7 },
        { name: 'Современная филология в преподавании литературы в школе', faculty_id: 7 },
        { name: 'Античная и восточная археология', faculty_id: 7 },
        { name: 'Русская литература и компаративистика', faculty_id: 7 },
        { name: 'История современного мира', faculty_id: 7 },
        { name: 'Языковая политика в условиях этнокультурного разнообразия', faculty_id: 7 },
        { name: 'Восточноевропейские исследования', faculty_id: 7 },
        { name: 'Мусульманские миры в России (История и культура)', faculty_id: 7 },
        { name: 'Лингвистическая теория и описание языка', faculty_id: 7 },
        { name: 'Germanica: история и современность', faculty_id: 7 },
        { name: 'Языки и литература Юго-Восточной Азии', faculty_id: 7 },
        { name: 'Медиевистика', faculty_id: 7 },
        { name: 'Современная филология в преподавании русского языка и литературы в школе', faculty_id: 7 },
        { name: 'Библеистика и история древнего Израиля', faculty_id: 7 },
        { name: 'Классический и современный Восток: языки, культуры, религии', faculty_id: 7 },
        { name: 'Язык, словесность и культура Кореи', faculty_id: 7 },
        { name: 'Религия и общество', faculty_id: 7 },
        { name: 'Язык, словесность и культура Китая', faculty_id: 7 },
        { name: 'Язык и литература Ирана', faculty_id: 7 },
        { name: 'Языки и литература Индии', faculty_id: 7 },
        { name: 'Язык и литература Японии', faculty_id: 7 },
        { name: 'Философия и история религии', faculty_id: 7 },
        { name: 'Ассириология', faculty_id: 7 },
        { name: 'Христианский Восток', faculty_id: 7 },
        { name: 'Египтология', faculty_id: 7 },
        { name: 'Эфиопия и арабский мир', faculty_id: 7 },
        { name: 'Монголия и Тибет', faculty_id: 7 },
        { name: 'Арабистика: язык, словесность, культура', faculty_id: 7 },
        { name: 'Турция и тюркский мир', faculty_id: 7 }
      ]
    },
    { name: 'Московский институт электроники и математики им. А.Н. Тихонова (Tikhonov Moscow Institute of Electronics and Mathematics)',
      programs: [
        { name: 'Информатика и вычислительная техника', faculty_id: 8 },
        { name: 'Информационная безопасность', faculty_id: 8 },
        { name: 'Прикладная математика', faculty_id: 8 },
        { name: 'Компьютерная безопасность', faculty_id: 8 },
        { name: 'Инфокоммуникационные технологии и системы связи', faculty_id: 8 },
        { name: 'Компьютерные системы и сети', faculty_id: 8 },
        { name: 'Кибербезопасность', faculty_id: 8 },
        { name: 'Системный анализ и математические технологии', faculty_id: 8 },
        { name: 'Интернет вещей и киберфизические системы', faculty_id: 8 },
        { name: 'Прикладная электроника и фотоника', faculty_id: 8 },
        { name: 'Информационная безопасность киберфизических систем', faculty_id: 8 },
        { name: 'Прикладные модели искусственного интеллекта', faculty_id: 8 }
      ]
    },
    { name: 'Факультет права (Faculty of Law)',
      programs: [
        { name: 'Юриспруденция', faculty_id: 9 },
        { name: 'Право', faculty_id: 9 },
        { name: 'Юрист в бизнесе', faculty_id: 9 },
        { name: 'Цифровое право', faculty_id: 9 },
        { name: 'Цифровой юрист', faculty_id: 9 },
        { name: 'Юрист в правосудии', faculty_id: 9 },
        { name: 'Корпоративное и международное частное право', faculty_id: 9 },
        { name: 'Юриспруденция: частное право', faculty_id: 9 },
        { name: 'Право международной торговли и разрешение споров', faculty_id: 9 },
        { name: 'ЛигалТех', faculty_id: 9 },
        { name: 'Фармправо и здравоохранение', faculty_id: 9 },
        { name: 'Комплаенс и профилактика правовых рисков', faculty_id: 9 },
        { name: 'Публичное право', faculty_id: 9 },
        { name: 'Юриспруденция: гражданское и предпринимательское право', faculty_id: 9 },
        { name: 'Публичное право и публичные финансы', faculty_id: 9 },
        { name: 'Теоретическое и сравнительное правоведение', faculty_id: 9 },
        { name: 'Право: исследовательская программа', faculty_id: 9 },
        { name: 'Правовое сопровождение бизнеса', faculty_id: 9 },
        { name: 'Право международной торговли, финансов и экономической интеграции', faculty_id: 9 },
        { name: 'Международное частное право и международный коммерческий арбитраж', faculty_id: 9 },
        { name: 'Правовое регулирование в фармацевтике и биотехнологиях', faculty_id: 9 },
        { name: 'История, теория и философия права', faculty_id: 9 },
        { name: 'Финансовое, налоговое и таможенное право', faculty_id: 9 },
        { name: 'Корпоративный юрист', faculty_id: 9 }
      ]
    },
    { name: 'Школа иностранных языков (School of Foreign Languages)',
      programs: [
        { name: 'Иностранные языки и межкультурная коммуникация', faculty_id: 10 }
      ]
    },
    { name: 'Факультет городского и регионального развития (Faculty of Urban and Regional Development)',
      programs: [
        { name: 'Городское планирование', faculty_id: 11 },
        { name: 'Управление пространственным развитием городов', faculty_id: 11 },
        { name: 'Цифровая урбанистика и аналитика города', faculty_id: 11 }
      ]
    },
    { name: 'Факультет математики (Faculty of Mathematics)',
      programs: [
        { name: 'Математика', faculty_id: 12 },
        { name: 'Совместный бакалавриат НИУ ВШЭ и ЦПМ', faculty_id: 12 },
        { name: 'Совместная магистратура НИУ ВШЭ и ЦПМ', faculty_id: 12 },
        { name: 'Математика и математическая физика', faculty_id: 12 }
      ]
    },
    { name: 'Факультет биологии и биотехнологии (Faculty of Biology and Biotechnology)',
      programs: [
        { name: 'Клеточная и молекулярная биотехнология', faculty_id: 13 },
        { name: 'Когнитивная нейробиология', faculty_id: 13 },
        { name: 'Биоэкономика', faculty_id: 13 }
      ]
    },
    { name: 'Факультет физики (Faculty of Physics)',
      programs: [
        { name: 'Физика', faculty_id: 14 }
      ]
    },
    { name: 'Факультет географии и геоинформационных технологий (Faculty of Geography and Geoinformation Technology)',
      programs: [
        { name: 'География глобальных изменений и геоинформационные технологии', faculty_id: 15 },
        { name: 'Управление низкоуглеродным развитием', faculty_id: 15 }
      ]
    },
    { name: 'Факультет химии (Faculty of Chemistry)',
      programs: [
        { name: 'Химия', faculty_id: 16 },
        { name: 'Химия молекулярных систем и материалов', faculty_id: 16 }
      ]
    } ]

@places = [ 'Покровский бульвар', 'Малая Пионерская', 'Онлайн', 'Другое' ]

# Функция очистки и наполнения бд через сиды
def seed
  reset_db
  create_users(10)
  create_tags
  create_events(20)
  create_faculties
  create_programs
  create_communities
  create_meets(10)
  create_event_comments(2..8)
  create_meet_comments(2..8)
  5.times do
    create_comment_replies
  end
end

# Функция очистки бд, которую встраиваем в seed
def reset_db
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
end

# Функция создания пользователей
def create_users(quantity)
  i = 0

  quantity.times do
      user_data = {
        email: "user_#{i}@email.com",
        password: "testtest",
        username: "user#{i}"
      }

      if i == 0
        user_data[:role] = "admin"
        user_data[:username] = "admin"
      end

      user = User.create!(user_data)
      puts "User created with id #{user.id}"
      i += 1
  end
end

# Функция создания ивентов (quantity раз)
def create_events(quantity)
  quantity.times do |i|
    user = User.all.sample
    event = Event.create(
      title: "Ивент №#{i + 1}",
      body: create_sentence,
      user_id: user.id,
      cover: upload_event_cover_image,
      hosted_at: Time.now,
      community_id: 1,
      placed_at: @places.sample)
    puts "Event with id #{event.id} just created!"
  end
end

# Функция создания митов (quantity раз)
def create_meets(quantity)
  quantity.times do |i|
    user = User.all.sample
    meet = Meet.create(
      body: create_sentence,
      user_id: user.id,
      hosted_at: Time.now)
    puts "Meet with id #{meet.id} just created!"
  end
end

# Функция создания комментариев ко всем ивентам (quantity слов в комментарии)
def create_event_comments(quantity)
  Event.all.each do |event|
      quantity.to_a.sample.times do
          user = User.all.sample
          comment = Comment.create(
            commentable_type: "Event",
            commentable_id: event.id,
            body: create_sentence,
            user_id: user.id)
          puts "Comment #{comment.id} for event #{comment.commentable.id} just created!"
      end
  end
end

# Функция создания комментариев ко всем митам (quantity слов в комментарии)
def create_meet_comments(quantity)
  Meet.all.each do |meet|
      quantity.to_a.sample.times do
          user = User.all.sample
          comment = Comment.create(
            commentable_type: "Meet",
            commentable_id: meet.id,
            body: create_sentence,
            user_id: user.id)
          puts "Comment #{comment.id} for meet #{comment.commentable.id} just created!"
      end
  end
end

# Функция ответов на комментарии (все)
def create_comment_replies
  Comment.all.shuffle.last(30).each do |comment|
    user = User.all.sample
    comment_reply = comment.replies.create(
      commentable_type: comment.commentable_type,
      commentable_id: comment.commentable.id,
      body: create_sentence,
      user_id: user.id)
    puts "Reply #{comment_reply.id} for #{comment_reply.commentable} #{comment_reply.commentable.id} just created!"
  end
end

# Функция создания факультетов
def create_faculties
  @faculties.each do |faculty|
      faculty = Faculty.create(name: faculty[:name])
      puts "Faculty #{ faculty.name } just created"
  end
end

# Функция создания программ
def create_programs
  @faculties.each do |faculty|
      faculty[:programs].each do |program|
          program = Program.create(program)
          puts "Program #{ program.name } just created"
      end
  end
end

# Функция создания сообществ
def create_communities
  @communities.each do |community|
      community = Community.create(community)
      puts "Community #{ community.title } with id #{ community.id } just created!"
  end
end

# Функция создания тегов
def create_tags
  tags = [
    { name: 'раз', tag_type: 'tag' },
    { name: 'два', tag_type: 'tag' },
    { name: 'три', tag_type: 'tag' },
    { name: 'четыре', tag_type: 'category' },
    { name: 'пять', tag_type: 'category' },
    { name: 'шесть', tag_type: 'category' }
  ]

  tags.each do |tag_data|
    Tag.create(tag_data)
    puts "Tag with #{ tag_data[:name] } was created"
  end
end

seed
