import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    // При инициализации скрываем меню
    this.hideMenu()
    // Навешиваем слушатель клика на кнопку
    this.buttonTarget.addEventListener("click", this.toggleMenu.bind(this))
    // Слушаем клик вне, чтобы прятать меню
    document.addEventListener("click", this.clickOutside.bind(this))
  }

  disconnect() {
    // Снимаем слушатели, когда контроллер «сбросится»
    this.buttonTarget.removeEventListener("click", this.toggleMenu.bind(this))
    document.removeEventListener("click", this.clickOutside.bind(this))
  }

  toggleMenu(event) {
    event.preventDefault()
    event.stopPropagation()
    this.menuTarget.hidden = !this.menuTarget.hidden
  }

  hideMenu() {
    this.menuTarget.hidden = true
  }

  clickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideMenu()
    }
  }
}
