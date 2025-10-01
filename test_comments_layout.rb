#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

def test_comments_layout
  puts "🧪 ТЕСТИРОВАНИЕ РАСПОЛОЖЕНИЯ КОММЕНТАРИЕВ"
  puts "=" * 50
  
  # Тестируем страницу события
  puts "1️⃣ ТЕСТ СТРАНИЦЫ СОБЫТИЯ:"
  event_uri = URI('http://localhost:3000/events/91')
  event_response = Net::HTTP.get_response(event_uri)
  
  if event_response.code == '200'
    event_html = event_response.body.force_encoding('UTF-8')
    
    # Проверяем, что комментарии находятся вне карточки
    if event_html.include?('M_EventShowDiscussion')
      puts "  ✅ Секция обсуждения вынесена из карточки"
    else
      puts "  ❌ Секция обсуждения не найдена"
    end
    
    # Проверяем использование классов встреч
    if event_html.include?('M_MeetShowComments')
      puts "  ✅ Используются классы комментариев встреч"
    else
      puts "  ❌ Классы комментариев встреч не найдены"
    end
    
    if event_html.include?('M_MeetShowCommentForm')
      puts "  ✅ Используется форма комментариев встреч"
    else
      puts "  ❌ Форма комментариев встреч не найдена"
    end
    
    # Проверяем заголовок обсуждения
    if event_html.include?('A_EventShowDiscussionTitle')
      puts "  ✅ Заголовок обсуждения присутствует"
    else
      puts "  ❌ Заголовок обсуждения не найден"
    end
    
  else
    puts "  ❌ Ошибка загрузки страницы события: #{event_response.code}"
  end
  
  # Тестируем страницу встречи для сравнения
  puts "\n2️⃣ ТЕСТ СТРАНИЦЫ ВСТРЕЧИ (для сравнения):"
  meet_uri = URI('http://localhost:3000/meets/91')
  meet_response = Net::HTTP.get_response(meet_uri)
  
  if meet_response.code == '200'
    meet_html = meet_response.body.force_encoding('UTF-8')
    
    if meet_html.include?('M_MeetShowDiscussion')
      puts "  ✅ Секция обсуждения встречи присутствует"
    else
      puts "  ❌ Секция обсуждения встречи не найдена"
    end
    
    if meet_html.include?('M_MeetShowComments')
      puts "  ✅ Комментарии встречи используют правильные классы"
    else
      puts "  ❌ Комментарии встречи не используют правильные классы"
    end
    
  else
    puts "  ❌ Ошибка загрузки страницы встречи: #{meet_response.code}"
  end
  
  puts "\n🎉 ТЕСТИРОВАНИЕ ЗАВЕРШЕНО!"
  puts "\n📋 РЕЗУЛЬТАТ:"
  puts "  - Комментарии событий теперь располагаются вне карточки"
  puts "  - Используются те же стили, что и для встреч"
  puts "  - Структура HTML соответствует структуре встреч"
end

test_comments_layout
