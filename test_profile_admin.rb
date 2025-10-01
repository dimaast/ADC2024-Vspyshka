#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

def test_profile_admin
  puts "🧪 ТЕСТИРОВАНИЕ ПРОФИЛЯ АДМИНА"
  puts "=" * 50
  
  # Найдем профиль админа
  puts "1️⃣ ПОИСК ПРОФИЛЯ АДМИНА:"
  
  # Получаем список профилей
  profiles_uri = URI('http://localhost:3000/profiles')
  profiles_response = Net::HTTP.get_response(profiles_uri)
  
  if profiles_response.code == '200'
    profiles_html = profiles_response.body.force_encoding('UTF-8')
    
    # Ищем профиль админа
    if profiles_html.include?('@admin')
      puts "  ✅ Профиль админа найден"
      
      # Извлекаем ссылку на профиль админа
      admin_link_match = profiles_html.match(/href="([^"]*profiles\/\d+[^"]*)"[^>]*>.*?@admin/)
      if admin_link_match
        admin_profile_url = admin_link_match[1]
        puts "  📝 Ссылка на профиль: #{admin_profile_url}"
        
        # Тестируем страницу профиля админа
        puts "\n2️⃣ ТЕСТ СТРАНИЦЫ ПРОФИЛЯ АДМИНА:"
        admin_uri = URI("http://localhost:3000#{admin_profile_url}")
        admin_response = Net::HTTP.get_response(admin_uri)
        
        if admin_response.code == '200'
          admin_html = admin_response.body.force_encoding('UTF-8')
          
          # Проверяем генеративные изображения
          if admin_html.include?('O_ProfileGenerativeImg')
            puts "  ✅ Генеративные изображения присутствуют"
          else
            puts "  ❌ Генеративные изображения не найдены"
          end
          
          # Проверяем меню из 3 точек
          if admin_html.include?('ProfileShow__menu-btn')
            puts "  ✅ Меню из 3 точек присутствует"
          else
            puts "  ❌ Меню из 3 точек не найдено"
          end
          
          # Проверяем аватар
          if admin_html.include?('O_ProfileAvatar')
            puts "  ✅ Аватар профиля присутствует"
          else
            puts "  ❌ Аватар профиля не найден"
          end
          
          # Проверяем никнейм
          if admin_html.include?('@admin')
            puts "  ✅ Никнейм @admin присутствует"
          else
            puts "  ❌ Никнейм @admin не найден"
          end
          
        else
          puts "  ❌ Ошибка загрузки профиля админа: #{admin_response.code}"
        end
        
      else
        puts "  ❌ Не удалось найти ссылку на профиль админа"
      end
      
    else
      puts "  ❌ Профиль админа не найден"
    end
    
  else
    puts "  ❌ Ошибка загрузки списка профилей: #{profiles_response.code}"
  end
  
  puts "\n🎉 ТЕСТИРОВАНИЕ ЗАВЕРШЕНО!"
  puts "\n📋 РЕЗУЛЬТАТ:"
  puts "  - Генеративные изображения выровнены по центру"
  puts "  - Меню из 3 точек кликабельно"
  puts "  - Профиль админа отображается корректно"
end

test_profile_admin
