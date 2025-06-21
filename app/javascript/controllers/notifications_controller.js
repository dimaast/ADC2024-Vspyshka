import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["panel", "button", "counter", "list"]

  connect() {
    // Подключаемся к каналу уведомлений
    this.subscription = consumer.subscriptions.create(
      { channel: "NotificationsChannel" },
      {
        connected: () => {
          console.log("NotificationsChannel: connected")
        },
        disconnected: () => {
          console.log("NotificationsChannel: disconnected")
        },
        received: (data) => {
          console.log("NotificationsChannel: received", data)
          this.prependNotification(data.body, data.url)
          this.incrementCounter()
        }
      }
    )
    document.addEventListener("click", this.closeIfClickedOutside)
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
    document.removeEventListener("click", this.closeIfClickedOutside)
  }

  toggle(event) {
    event.stopPropagation()
    const isVisible = this.panelTarget.classList.contains('is-open')
    
    if (isVisible) {
      this.panelTarget.classList.remove('is-open')
    } else {
      this.panelTarget.classList.add('is-open')
    }
    
    // Закрываем другие панели, если нужно
    document.querySelectorAll('.NotificationsPanel').forEach(panel => {
      if (panel !== this.panelTarget) panel.classList.remove('is-open');
    });
  }

  closeIfClickedOutside = (event) => {
    if (!this.element.contains(event.target)) {
      this.panelTarget.classList.remove('is-open')
    }
  }

  prependNotification(body, url) {
    const notification = document.createElement("div")
    notification.className = "notification notification--new"
    notification.innerHTML = `<a href="${url}">${body}</a>`
    this.listTarget.insertBefore(notification, this.listTarget.firstChild)
  }

  incrementCounter() {
    const counter = this.counterTarget
    const currentCount = parseInt(counter.textContent) || 0
    counter.textContent = currentCount + 1
    this.buttonTarget.classList.add("has-unread")
  }
}
