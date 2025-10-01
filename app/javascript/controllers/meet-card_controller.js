import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  navigate(event) {
    event.preventDefault()
    event.stopPropagation()
    
    // Проверяем, что клик не по закладке
    if (event.target.closest('.Q_BookmarkIconNoBg')) {
      return
    }
    
    // Получаем ID встречи из data-атрибута
    const meetId = this.element.dataset.meetId
    
    if (meetId) {
      // Переходим на страницу встречи
      window.location.href = `/meets/${meetId}`
    }
  }
}
