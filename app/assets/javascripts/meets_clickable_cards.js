document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.M_MeetCard[data-url]').forEach(function(card) {
    card.style.cursor = 'pointer';
    card.addEventListener('click', function(e) {
      // Не переходить по ссылке, если клик был по внутренней ссылке или кнопке
      if (e.target.closest('a, button')) return;
      window.location = card.getAttribute('data-url');
    });
  });
}); 