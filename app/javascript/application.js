// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "channels"
import "@hotwired/turbo-rails"
import "controllers"
import "./events_filters"

// Отладка для страницы события
document.addEventListener("DOMContentLoaded", function() {
  console.log("DOM loaded, current path:", window.location.pathname);
  if (window.location.pathname.includes('/events/') && !window.location.pathname.endsWith('/events')) {
    console.log("Event page loaded");
  }
  
  // Отключаем Turbo только для ссылок на конкретные события (не для фильтрации)
  document.addEventListener('click', function(e) {
    const link = e.target.closest('a[href*="/events/"]');
    if (link) {
      const href = link.href;
      // Проверяем, что это ссылка на конкретное событие (содержит число после /events/)
      if (href.match(/\/events\/\d+/) && !href.includes('by_tag')) {
        e.preventDefault();
        window.location.href = href;
      }
    }
  });
});

