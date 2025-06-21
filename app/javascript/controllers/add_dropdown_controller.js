import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  toggle(event) {
    event.stopPropagation();
    const isVisible = this.menuTarget.classList.contains('is-open');
    
    if (isVisible) {
      this.menuTarget.classList.remove('is-open');
    } else {
      this.menuTarget.classList.add('is-open');
    }
    
    // Закрываем другие меню, если нужно
    document.querySelectorAll('.AddDropdownMenu').forEach(menu => {
      if (menu !== this.menuTarget) menu.classList.remove('is-open');
    });
  }

  connect() {
    document.addEventListener("click", this.closeIfClickedOutside);
  }

  disconnect() {
    document.removeEventListener("click", this.closeIfClickedOutside);
  }

  closeIfClickedOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.remove('is-open');
    }
  }
}
