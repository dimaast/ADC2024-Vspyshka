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

# JTI токены для кук
# rails g migration add_jti_to_users jti:string
# в миграции , null: false add_index :users, :jti, unique: true
# rails db:migrate
# для юзер сидов добавляем jti: SecureRandom.uuid
# rails db:drop
# rails db:seed
# в юзер модель include Devise::JWT::RevocationStrategies::JTIMatcher devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self
# gemfile gem "devise-jwt"
# можно в целом убрать jti из юзер сидов
# проверяем в апликейшн контроллере
# def authenticate_user
#   if current_user
#     if cookies[:guest_token]
#       puts cookies[:guest_token] == current_user.jti
#     else
#       cookies[:guest_token] = current_user.jti
#     end
#   end
# end

# API на запись (аутентификация)
# лучше пересматривать пару это треш

# Автообновление лайков и респонсов
#

# db/seeds.rb

# Генерация случайных предложений (для body ивентов и митов)
@raw_text = <<~TEXT
  Дом Наркомфина — один из знаковых памятников архитектуры советского авангарда и конструктивизма.
  Построен в 1928—1930 годах по проекту архитекторов Моисея Гинзбурга, Игнатия Милиниса и инженера Сергея Прохорова
  для работников Народного комиссариата финансов СССР (Наркомфина). Автор замысла дома Наркомфина Гинзбург определял
  его как «опытный дом переходного типа». Дом находится в Москве по адресу: Новинский бульвар, дом 25, корпус 1.
  С начала 1990-х годов дом находился в аварийном состоянии, был трижды включён в список «100 главных зданий мира,
  которым грозит уничтожение». В 2017—2020 годах отреставрирован по проекту АБ «Гинзбург Архитектс», функционирует
  как элитный жилой дом. Отдельно стоящий «Коммунальный блок» (историческое название) планируется как место проведения
  публичных мероприятий.
TEXT

@words = @raw_text
           .downcase
           .gsub(/[—.—,«»:()]/, "")
           .gsub(/\s+/, " ")
           .strip
           .split(" ")

def create_sentence
  sentence = []
  rand(10..20).times { sentence << @words.sample }
  sentence.join(" ").capitalize + "."
end

# Функции загрузки случайных обложек (CarrierWave или аналог)
def upload_event_cover_image
  begin
    uploader = CoverUploader.new(Event.new, :cover)
    upload_path = File.join(Rails.root, "public/autoupload/events")
    
    # Проверяем, существует ли папка
    if Dir.exist?(upload_path)
      random_file = Dir.glob(File.join(upload_path, "*.{jpg,jpeg,png,gif}")).sample
      if random_file
        uploader.cache!(File.open(random_file))
        return uploader
      end
    end
    
    # Если папка не существует или файлы не найдены, возвращаем nil
    puts "Warning: No event cover images found in #{upload_path}"
    return nil
  rescue => e
    puts "Error uploading event cover image: #{e.message}"
    return nil
  end
end

def upload_community_cover_image
  begin
    uploader = CommunityCoverUploader.new(Community.new, :cover)
    upload_path = File.join(Rails.root, "public/autoupload/communities")
    
    # Проверяем, существует ли папка
    if Dir.exist?(upload_path)
      random_file = Dir.glob(File.join(upload_path, "*.{jpg,jpeg,png}")).sample
      if random_file
        uploader.cache!(File.open(random_file))
        return uploader
      end
    end
    
    # Если папка не существует или файлы не найдены, возвращаем nil
    puts "Warning: No community cover images found in #{upload_path}"
    return nil
  rescue => e
    puts "Error uploading community cover image: #{e.message}"
    return nil
  end
end

# Места для ивентов
@places = [
  "Покровский бульвар",
  "Малая Пионерская",
  "Онлайн",
  "Другое"
]

# Список сообществ
@communities = [
  {
    title: "Центр лидерства и волонтёрства",
    user_id: 1,
    cover: upload_community_cover_image,
    contact: "https://vk.com/hse_volunteers",
    body: "Волонтёрский центр Вышки – это команда инициативных и неравнодушных студентов, выпускников и сотрудников университета. Мы помогаем с организацией самых крупных вышкинских проектов: развлекательных и научных. Участвуем в городских фестивалях и конференциях. А ещё помогаем старшему поколению онлайн изучать иностранные языки и школьникам из Москвы и регионов не отставать по школьным предметам."
  },
  {
    title: "Студенческий совет НИУ ВШЭ",
    user_id: 1,
    cover: upload_community_cover_image,
    contact: "https://vk.com/hsecouncil",
    body: "Студсовет Вышки"
  },
  {
    title: "HSE Outreach",
    user_id: 1,
    cover: upload_community_cover_image,
    contact: "https://vk.com/hseoutreach",
    body: "HSE Outreach — старейшая и одна из крупнейших благотворительных организаций в Вышке."
  },
  {
    title: 'Экологический клуб "Зелёная Вышка"',
    user_id: 1,
    cover: upload_community_cover_image,
    contact: "https://vk.com/hsegreen",
    body: "Экологический клуб"
  },
  {
    title: "Спортивный клуб",
    user_id: 1,
    cover: upload_community_cover_image,
    contact: "https://vk.com/hsessc",
    body: "Спорт для нас — не только здоровый образ жизни. Это люди, традиции и гордость нашего университета."
  },
  {
    title: "InsideOut",
    user_id: 1,
    cover: upload_community_cover_image,
    contact: "https://vk.com/insideout_hse",
    body: "InsideOut – студенческая организация, выворачивающая «наизнанку» стереотипы об однообразной жизни студентов факультета Мировой Экономики и Мировой Политики."
  },
  {
    title: "Клуб вьетнамской культуры",
    user_id: 1,
    cover: upload_community_cover_image,
    contact: "https://vk.com/vietnamculturehse",
    body: "Xin chào! Мы – клуб вьетнамской культуры ВШЭ, сообщество энтузиастов, исследующих жизнь Вьетнама."
  }
]

# Список факультетов с программами
@faculties = [
  {
    name: "Факультет креативных индустрий (Faculty of Creative Industries)",
    programs: [
      { name: "Дизайн", faculty_id: 1 },
      { name: "Реклама и связи с общественностью", faculty_id: 1 },
      { name: "Медиакоммуникации", faculty_id: 1 },
      { name: "Журналистика", faculty_id: 1 },
      { name: "Мода", faculty_id: 1 },
      { name: "Современное искусство", faculty_id: 1 },
      { name: "Стратегия и продюсирование в коммуникациях", faculty_id: 1 },
      { name: "Коммуникационный и цифровой дизайн", faculty_id: 1 },
      { name: "Кинопроизводство", faculty_id: 1 },
      { name: "Управление в креативных индустриях", faculty_id: 1 },
      { name: "Управление стратегическими коммуникациями", faculty_id: 1 },
      { name: "Интегрированные коммуникации", faculty_id: 1 },
      { name: "Трансмедийное производство в цифровых индустриях", faculty_id: 1 },
      { name: "Современная журналистика", faculty_id: 1 },
      { name: "Медиаменеджмент", faculty_id: 1 },
      { name: "Практики современного искусства", faculty_id: 1 },
      { name: 'Программа двух дипломов НИУ ВШЭ и ДГТУ "Нейромедиа"', faculty_id: 1 },
      { name: "Актер", faculty_id: 1 },
      { name: "Коммуникации в государственных структурах и НКО", faculty_id: 1 },
      { name: "Коммуникации, основанные на данных", faculty_id: 1 },
      { name: "Практики кураторства в современном искусстве", faculty_id: 1 },
      { name: "Критические медиаисследования", faculty_id: 1 },
      { name: "Дизайн среды", faculty_id: 1 },
      { name: "Современные технологии преподавания дизайна и искусства", faculty_id: 1 },
      { name: "Современный дизайн в преподавании изобразительного искусства и технологии в школе", faculty_id: 1 }
    ]
  },
  {
    name: "Факультет мировой экономики и мировой политики (Faculty of World Economy and International Affairs)",
    programs: [
      { name: "Востоковедение", faculty_id: 6 },
      { name: "Мировая экономика", faculty_id: 6 },
      { name: 'Программа двух дипломов НИУ ВШЭ и Университета Кёнхи "Экономика и политика в Азии"', faculty_id: 6 },
      { name: "Международные отношения", faculty_id: 6 },
      { name: 'Международная программа "Международные отношения и глобальные исследования"', faculty_id: 6 },
      { name: "Международные отношения: европейские и азиатские исследования", faculty_id: 6 },
      { name: "Социально-экономическое и политическое развитие современной Азии", faculty_id: 6 },
      { name: 'Программа двух дипломов НИУ ВШЭ и Университета Кёнхи "Экономика, политика и бизнес в Азии"', faculty_id: 6 },
      { name: "Экономика окружающей среды и устойчивое развитие", faculty_id: 6 }
    ]
  }
]

# Массивы для генерации случайных данных пользователей
@first_names = [
  "Александр", "Алексей", "Андрей", "Артём", "Владимир", "Дмитрий", "Евгений", "Иван", "Максим", "Михаил",
  "Николай", "Павел", "Пётр", "Сергей", "Степан", "Тимофей", "Фёдор", "Юрий", "Ярослав", "Антон",
  "Анна", "Елена", "Екатерина", "Ирина", "Мария", "Наталья", "Ольга", "Светлана", "Татьяна", "Юлия",
  "Алиса", "Анастасия", "Валентина", "Вера", "Галина", "Дарья", "Елизавета", "Зинаида", "Инна", "Кристина"
]

@last_names = [
  "Иванов", "Смирнов", "Кузнецов", "Попов", "Васильев", "Петров", "Соколов", "Михайлов", "Новиков", "Фёдоров",
  "Морозов", "Волков", "Алексеев", "Лебедев", "Семёнов", "Егоров", "Павлов", "Козлов", "Степанов", "Николаев",
  "Орлов", "Андреев", "Макаров", "Никитин", "Захаров", "Зайцев", "Соловьёв", "Борисов", "Яковлев", "Григорьев",
  "Романов", "Воробьёв", "Сергеев", "Кузьмин", "Фролов", "Александров", "Дмитриев", "Королёв", "Гусев", "Киселёв"
]

@middle_names = [
  "Александрович", "Алексеевич", "Андреевич", "Артёмович", "Владимирович", "Дмитриевич", "Евгеньевич", "Иванович", "Максимович", "Михайлович",
  "Николаевич", "Павлович", "Петрович", "Сергеевич", "Степанович", "Тимофеевич", "Фёдорович", "Юрьевич", "Ярославович", "Антонович",
  "Александровна", "Алексеевна", "Андреевна", "Артёмовна", "Владимировна", "Дмитриевна", "Евгеньевна", "Ивановна", "Максимовна", "Михайловна",
  "Николаевна", "Павловна", "Петровна", "Сергеевна", "Степановна", "Тимофеевна", "Фёдоровна", "Юрьевна", "Ярославовна", "Антоновна"
]

@usernames = [
  "alex_dev", "coder_max", "web_master", "tech_guru", "code_ninja", "digital_wizard", "byte_buddy", "script_kid", "debug_master", "git_hacker",
  "ruby_rover", "rails_runner", "js_jumper", "css_crafter", "html_hero", "sql_sage", "api_ace", "cloud_captain", "data_dragon", "frontend_fox",
  "backend_bear", "fullstack_falcon", "devops_dolphin", "qa_queen", "ui_unicorn", "ux_wizard", "mobile_monkey", "desktop_dog", "server_shark", "client_cat",
  "programmer_panda", "developer_deer", "engineer_eagle", "architect_ant", "designer_duck", "analyst_antelope", "tester_tiger", "scrum_squirrel", "agile_ape", "lean_lion"
]

# Основная функция seed
def seed
  reset_db
  ActsAsTaggableOn::Tag.reset_column_information
  # Создаём тестовых пользователей
  begin
    admin = User.create!(
      username: 'admin',
      email: 'admin@edu.hse.ru',
      password: 'password',
      password_confirmation: 'password',
      role: 'admin',
      first_name: 'Админ',
      last_name: 'Администраторов',
      middle_name: 'Админович'
    )
    puts "Admin создан"
  rescue ActiveRecord::RecordInvalid => e
    puts "Ошибка при создании admin: #{e.record.errors.full_messages.join(', ')}"
  end
  9.times do |i|
    begin
      User.create!(
        username: "user#{i+1}",
        email: "user#{i+1}@edu.hse.ru",
        password: 'password',
        password_confirmation: 'password',
        role: 'user',
        first_name: "Имя#{i+1}",
        last_name: "Фамилия#{i+1}",
        middle_name: "Отчествович#{i+1}"
      )
      puts "User user#{i+1} создан"
    rescue ActiveRecord::RecordInvalid => e
      puts "Ошибка при создании user#{i+1}: #{e.record.errors.full_messages.join(', ')}"
    end
  end
  create_tags
  create_faculties
  create_communities
  create_events(10)
  create_meets(10)

  # Проверка связей тегов и категорий
  puts "\nПроверка тегов и категорий у событий:"
  Event.all.each do |event|
    puts "Событие: #{event.title}"
    puts "  Теги: #{event.tag_list.join(', ')}"
    puts "  Категории: #{event.category_list.join(', ')}"
  end
  puts "\nВсе теги в системе: #{ActsAsTaggableOn::Tag.all.map(&:name).join(', ')}"
  puts "Всего связей (taggings): #{ActsAsTaggableOn::Tagging.count}"
end

# Сбрасываем и создаём базу заново
def reset_db
  puts 'Очищаю базу данных...'
  # Удаляем все связанные данные в правильном порядке
  Favourite.delete_all
  Response.delete_all
  Report.delete_all
  Comment.delete_all
  Event.delete_all
  Meet.delete_all
  Community.delete_all
  Program.delete_all
  Faculty.delete_all
  Profile.delete_all
  User.delete_all
  ActsAsTaggableOn::Tagging.delete_all   # СНАЧАЛА taggings!
  ActsAsTaggableOn::Tag.delete_all       # ПОТОМ tags!
  EmailSubscription.delete_all
  puts 'База данных очищена.'
end

def create_tags
  tag_names = %w[музыка спорт дизайн кино волонтёрство технологии еда игры]
  category_names = %w[концерт лекция фестиваль мастер-класс турнир]

  # Удаляем все теги с этими именами (любого типа)
  ActsAsTaggableOn::Tag.where(name: tag_names + category_names).delete_all

  tag_names.each do |tag|
    ActsAsTaggableOn::Tag.find_or_create_by!(name: tag, tag_type: "tag")
  end
  category_names.each do |cat|
    ActsAsTaggableOn::Tag.find_or_create_by!(name: cat, tag_type: "category")
  end
end

def create_faculties
  @faculties.each_with_index do |faculty_data, idx|
    faculty = Faculty.create!(name: faculty_data[:name])
    # Создаём программы для факультета
    if faculty_data[:programs]
      faculty_data[:programs].each do |program_data|
        Program.create!(name: program_data[:name], faculty: faculty)
      end
    end
  end
end

def create_communities
  user = User.first
  @communities.each do |community_data|
    Community.create!(
      title: community_data[:title],
      user: user,
      cover: community_data[:cover],
      contact: community_data[:contact],
      body: community_data[:body]
    )
  end
end

def create_events(_count)
  puts "User count before events: #{User.count}"
  puts "Users: #{User.all.map(&:email).join(", ")}"
  covers = [
    "img1.jpg", "img2.jpg", "img4.jpg", "img5.jpg", "img7.jpg"
  ]
  tag_list = %w[музыка спорт дизайн кино волонтёрство технологии еда игры]
  category_list = %w[концерт лекция фестиваль мастер-класс турнир]
  communities = Community.all.to_a
  events = [
    { title: 'Концерт современной музыки', body: 'Приглашаем на вечер живой музыки с участием молодых исполнителей. В программе — авторские композиции и каверы на известные хиты.', place: 'Покровский бульвар', price: '500', date: Date.today + 3.days },
    { title: 'Конференция по дизайну', body: 'Ведущие дизайнеры расскажут о трендах в графическом и промышленном дизайне. Мастер-классы и нетворкинг.', place: 'Онлайн', price: 'Бесплатно', date: Date.today + 7.days },
    { title: 'Киноночь: Классика мирового кино', body: 'Просмотр и обсуждение культовых фильмов XX века. Вход свободный, попкорн за наш счёт!', place: 'Малая Пионерская', price: 'Бесплатно', date: Date.today + 1.day },
    { title: 'Благотворительный забег', body: 'Спортивное мероприятие для всех желающих. Все собранные средства пойдут на поддержку детских домов.', place: 'Покровский бульвар', price: '300', date: Date.today + 10.days },
    { title: 'Лекция: Искусственный интеллект', body: 'Эксперт по ИИ расскажет о современных достижениях и перспективах развития искусственного интеллекта.', place: 'Онлайн', price: 'Бесплатно', date: Date.today + 5.days },
    { title: 'Фестиваль уличной еды', body: 'Лучшие фудтраки города, дегустации, мастер-классы от шеф-поваров и живая музыка.', place: 'Другое', price: 'Вход свободный', date: Date.today + 14.days },
    { title: 'Турнир по настольным играм', body: 'Соревнования по самым популярным настольным играм. Призы победителям!', place: 'Покровский бульвар', price: '200', date: Date.today + 2.days },
    { title: 'Мастер-класс по фотографии', body: 'Профессиональный фотограф поделится секретами удачных снимков. Практика на свежем воздухе.', place: 'Малая Пионерская', price: '400', date: Date.today + 4.days },
    { title: 'Воркшоп: Публичные выступления', body: 'Научитесь уверенно выступать перед аудиторией. Практические упражнения и обратная связь.', place: 'Онлайн', price: 'Бесплатно', date: Date.today + 6.days },
    { title: 'Квиз по истории', body: 'Интеллектуальная игра для команд. Проверьте свои знания и выиграйте призы!', place: 'Другое', price: '100', date: Date.today + 8.days }
  ]
  events.each_with_index do |attrs, idx|
    event = Event.new(
      title: attrs[:title],
      body: attrs[:body],
      placed_at: attrs[:place],
      price: attrs[:price],
      hosted_at: attrs[:date],
      user: User.all.sample
    )
    # Примерно половина событий будет с community
    if communities.any? && idx.even?
      event.community = communities.sample
    end
    # Обложка
    cover_file = covers[idx % covers.length]
    event.cover = File.open(Rails.root.join('app/assets/images', cover_file))
    # Теги и категории
    event.tag_list = tag_list.sample(2)
    event.category_list = category_list.sample(1)
    event.save!
  end
end

def create_meets(_count)
  puts "User count before meets: #{User.count}"
  puts "Users: #{User.all.map(&:email).join(", ")}"
  meets = [
    { body: 'Дружеская встреча для всех, кто любит настолки. Приносите свои любимые игры и делитесь опытом! Это отличная возможность познакомиться с новыми людьми и попробовать что-то новое.', placed_at: 'Покровский бульвар', date: Date.today + 2.days },
    { body: 'Практика английского языка в неформальной обстановке. Для любого уровня. Общение, игры, обсуждение фильмов и книг на английском языке. Приходите и совершенствуйте свой английский вместе с нами!', placed_at: 'Онлайн', date: Date.today + 3.days },
    { body: 'Принесите книги, которые хотите обменять, и найдите для себя что-то новое. Здесь вы сможете познакомиться с интересными людьми, обсудить любимые произведения и расширить свою библиотеку.', placed_at: 'Малая Пионерская', date: Date.today + 5.days },
    { body: 'Совместная поездка по живописным маршрутам города. Не забудьте шлем! Вас ждёт отличная компания, свежий воздух и новые впечатления. Присоединяйтесь к нашему велосообществу!', placed_at: 'Другое', date: Date.today + 7.days },
    { body: 'Смотрим и обсуждаем новинки и классику кино. Чай и печенье прилагаются. После просмотра делимся впечатлениями, обсуждаем режиссуру и актёрскую игру.', placed_at: 'Покровский бульвар', date: Date.today + 1.day },
    { body: 'Встреча для всех, кто любит рисовать, лепить или заниматься рукоделием. Приносите свои материалы и делитесь творческими идеями. Здесь вы найдёте единомышленников и вдохновение.', placed_at: 'Онлайн', date: Date.today + 4.days },
    { body: 'Утренняя зарядка на свежем воздухе для бодрого начала дня. Простые упражнения, хорошее настроение и поддержка друг друга гарантированы!', placed_at: 'Другое', date: Date.today + 6.days },
    { body: 'Обсуждаем актуальные темы и учимся аргументировать свою точку зрения. Встреча для тех, кто любит дискуссии, новые знания и интересные знакомства.', placed_at: 'Малая Пионерская', date: Date.today + 8.days },
    { body: 'Групповая прогулка с фотоаппаратами по интересным местам города. Обмениваемся советами, делаем красивые снимки и просто хорошо проводим время.', placed_at: 'Покровский бульвар', date: Date.today + 9.days },
    { body: 'Тёплая встреча для всех, кто когда-либо учился в нашем университете. Вспоминаем лучшие моменты, делимся новостями и строим планы на будущее.', placed_at: 'Онлайн', date: Date.today + 10.days }
  ]
  meets.each do |attrs|
    Meet.create!(
      body: attrs[:body],
      placed_at: attrs[:placed_at],
      hosted_at: attrs[:date],
      user: User.all.sample
    )
  end
end

seed

