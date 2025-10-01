#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

def test_homepage_events
  puts "🧪 ТЕСТИРОВАНИЕ СОБЫТИЙ НА ГЛАВНОЙ СТРАНИЦЕ"
  puts "=" * 50
  
  # Получаем главную страницу
  uri = URI('http://localhost:3000/')
  response = Net::HTTP.get_response(uri)
  
  if response.code == '200'
    html_content = response.body.force_encoding('UTF-8')
    
    # Проверяем, что события из seeds отображаются
    seed_events = [
      'Вечер презентаций альбома «Reputation»',
      'Heatwave Sounds',
      'ДИСКОТЕКА 80-90х',
      'Музыкальный фестиваль иконок'
    ]
    
    puts "✅ ПРОВЕРКА СОБЫТИЙ ИЗ SEEDS:"
    seed_events.each do |event_title|
      if html_content.include?(event_title)
        puts "  ✅ #{event_title} - отображается"
      else
        puts "  ❌ #{event_title} - НЕ отображается"
      end
    end
    
    # Проверяем, что есть события с паттерном "Событие №"
    if html_content.include?('Событие №')
      puts "  ✅ События с паттерном 'Событие №' - отображаются"
    else
      puts "  ❌ События с паттерном 'Событие №' - НЕ отображаются"
    end
    
    # Проверяем, что НЕ отображаются события, созданные вручную
    manual_events = [
      'Тестовое событие',
      'Тестовое событие для iOS'
    ]
    
    puts "\n✅ ПРОВЕРКА ОТСУТСТВИЯ СОБЫТИЙ, СОЗДАННЫХ ВРУЧНУЮ:"
    manual_events.each do |event_title|
      if html_content.include?(event_title)
        puts "  ❌ #{event_title} - ОТОБРАЖАЕТСЯ (не должно быть!)"
      else
        puts "  ✅ #{event_title} - НЕ отображается (правильно)"
      end
    end
    
    # Подсчитываем общее количество событий на странице
    event_count = html_content.scan(/class="event-title"/).length
    puts "\n📊 СТАТИСТИКА:"
    puts "  Всего событий на главной странице: #{event_count}"
    
    puts "\n🎉 ТЕСТИРОВАНИЕ ЗАВЕРШЕНО!"
    
  else
    puts "❌ Ошибка загрузки главной страницы: #{response.code}"
  end
end

test_homepage_events
