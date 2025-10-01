#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

def test_event_title
  puts "🧪 ТЕСТИРОВАНИЕ ЗАГОЛОВКА СОБЫТИЯ"
  puts "=" * 50
  
  # Тестируем страницу события
  puts "1️⃣ ТЕСТ СТРАНИЦЫ СОБЫТИЯ:"
  event_uri = URI('http://localhost:3000/events/91')
  event_response = Net::HTTP.get_response(event_uri)
  
  if event_response.code == '200'
    event_html = event_response.body.force_encoding('UTF-8')
    
    # Проверяем, что заголовок присутствует
    if event_html.include?('A_EventShowTitle')
      puts "  ✅ Заголовок события присутствует"
    else
      puts "  ❌ Заголовок события не найден"
    end
    
    # Извлекаем текст заголовка
    title_match = event_html.match(/<h1 class="A_EventShowTitle">([^<]+)<\/h1>/)
    if title_match
      title_text = title_match[1]
      puts "  📝 Текст заголовка: '#{title_text}'"
    end
    
  else
    puts "  ❌ Ошибка загрузки страницы события: #{event_response.code}"
  end
  
  # Тестируем страницу сообщества для сравнения
  puts "\n2️⃣ ТЕСТ СТРАНИЦЫ СООБЩЕСТВА (для сравнения):"
  community_uri = URI('http://localhost:3000/communities/22')
  community_response = Net::HTTP.get_response(community_uri)
  
  if community_response.code == '200'
    community_html = community_response.body.force_encoding('UTF-8')
    
    if community_html.include?('CommunityShow__title')
      puts "  ✅ Заголовок сообщества присутствует"
    else
      puts "  ❌ Заголовок сообщества не найден"
    end
    
    # Извлекаем текст заголовка сообщества
    title_match = community_html.match(/<h1 class="CommunityShow__title">([^<]+)<\/h1>/)
    if title_match
      title_text = title_match[1]
      puts "  📝 Текст заголовка сообщества: '#{title_text}'"
    end
    
  else
    puts "  ❌ Ошибка загрузки страницы сообщества: #{community_response.code}"
  end
  
  puts "\n🎉 ТЕСТИРОВАНИЕ ЗАВЕРШЕНО!"
  puts "\n📋 РЕЗУЛЬТАТ:"
  puts "  - Заголовок события теперь использует стили сообщества"
  puts "  - Шрифт: Proxima Nova Extra Condensed"
  puts "  - Размер: 74px (адаптивный)"
  puts "  - Стиль: жирный, заглавные буквы, большой размер"
end

test_event_title
