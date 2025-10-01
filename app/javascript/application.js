import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", function() {
  if (window.location.pathname.includes('/events/') && !window.location.pathname.endsWith('/events')) {
    document.addEventListener('click', function(e) {
      const link = e.target.closest('a[href*="/events/"]');
      if (link) {
        const href = link.href;
        if (href.match(/\/events\/\d+/) && !href.includes('by_tag')) {
          e.preventDefault();
          window.location.href = href;
        }
      }
    });
  }
});

