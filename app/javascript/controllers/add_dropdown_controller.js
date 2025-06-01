import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  connect() {
    // Закрываем меню, если кликнули где-то вне него
    this._outsideClickHandler = this.closeIfClickedOutside.bind(this);
    window.addEventListener("click", this._outsideClickHandler);
  }

  disconnect() {
    window.removeEventListener("click", this._outsideClickHandler);
  }

  toggle(event) {
    event.stopPropagation();
    if (this.menuTarget.hasAttribute("hidden")) {
      this.menuTarget.removeAttribute("hidden");
      this.menuTarget.classList.add("is-open");
    } else {
      this.menuTarget.setAttribute("hidden", "");
      this.menuTarget.classList.remove("is-open");
    }
  }

  closeIfClickedOutside(event) {
    if (
      this.hasMenuTarget &&
      !this.menuTarget.contains(event.target) &&
      !this.element.contains(event.target)
    ) {
      this.menuTarget.setAttribute("hidden", "");
      this.menuTarget.classList.remove("is-open");
    }
  }
}
