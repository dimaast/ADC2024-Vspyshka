import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  static values = { 
    menuClass: String 
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const isVisible = this.menuTarget.classList.contains('is-open')
    
    if (isVisible) {
      this.closeMenu()
    } else {
      this.openMenu()
    }
  }
  
  openMenu() {
    // Определяем класс меню из data-value или по содержимому
    const menuClass = this.menuClassValue || this.detectMenuClass()
    
    document.querySelectorAll(menuClass).forEach(menu => {
      if (menu !== this.menuTarget) {
        menu.classList.remove('is-open')
      }
    })
    
    this.menuTarget.style.display = 'block'
    requestAnimationFrame(() => {
      this.menuTarget.classList.add('is-open')
    })
  }
  
  closeMenu() {
    this.menuTarget.classList.remove('is-open')
    setTimeout(() => {
      if (!this.menuTarget.classList.contains('is-open')) {
        this.menuTarget.style.display = 'none'
      }
    }, 300)
  }

  connect() {
    document.addEventListener("click", this.closeIfClickedOutside)
    if (this.menuTarget) {
      this.menuTarget.addEventListener("click", this.handleMenuClick)
    }
  }

  disconnect() {
    document.removeEventListener("click", this.closeIfClickedOutside)
    if (this.menuTarget) {
      this.menuTarget.removeEventListener("click", this.handleMenuClick)
    }
  }

  handleMenuClick = (event) => {
    if (event.target.closest('a')) {
      this.closeMenu()
    }
  }

  closeIfClickedOutside = (event) => {
    const menuClass = this.menuClassValue || this.detectMenuClass()
    
    if (!this.element.contains(event.target) && !event.target.closest(menuClass)) {
      this.closeMenu()
    }
  }

  // Автоматически определяем класс меню по содержимому
  detectMenuClass() {
    if (this.menuTarget.classList.contains('M_AddDropdownMenu')) {
      return '.M_AddDropdownMenu'
    } else if (this.menuTarget.classList.contains('M_ProfileDropdownMenu')) {
      return '.M_ProfileDropdownMenu'
    }
    // Fallback - используем класс самого меню
    return `.${this.menuTarget.className.split(' ')[0]}`
  }
}
