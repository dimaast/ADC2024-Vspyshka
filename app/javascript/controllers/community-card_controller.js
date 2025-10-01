import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  navigate(event) {
    event.preventDefault()
    event.stopPropagation()
    
    // Проверяем, что клик не по тегу
    if (event.target.closest('.CommunityCard__tag')) {
      return
    }
    
    // Получаем ID сообщества из data-атрибута
    const communityId = this.element.dataset.communityId
    
    if (communityId) {
      // Переходим на страницу сообщества
      window.location.href = `/communities/${communityId}`
    }
  }
}
