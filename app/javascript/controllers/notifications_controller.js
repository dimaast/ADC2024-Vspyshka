import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["panel", "button", "counter", "list"]

  connect() {
    this.subscription = consumer.subscriptions.create(
      { channel: "NotificationsChannel" },
      {
        connected: () => {
        },
        disconnected: () => {
        },
        received: (data) => {
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
    event.preventDefault()
    event.stopPropagation()
    
    if (!this.panelTarget) {
      return
    }
    
    const isVisible = this.panelTarget.classList.contains('is-open')
    
    if (isVisible) {
      this.panelTarget.classList.remove('is-open')
    } else {
      this.panelTarget.classList.add('is-open')
    }
    
    document.querySelectorAll('.O_NotificationsPanel').forEach(panel => {
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
    notification.className = "O_Notification"
    if (url) {
      notification.innerHTML = `<a href="${url}" class="notification-link">${body}</a>`
    } else {
      notification.textContent = body
    }
    this.listTarget.insertBefore(notification, this.listTarget.firstChild)
  }

  incrementCounter() {
    const counter = this.counterTarget
    const currentCount = parseInt(counter.textContent) || 0
    counter.textContent = currentCount + 1
    this.buttonTarget.classList.add("has-unread")
  }

  markAsRead(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const notificationElement = event.currentTarget
    const notificationId = notificationElement.dataset.notificationId
    
    if (notificationId) {
      fetch(`/notifications/${notificationId}/mark_read`, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        }
      }).then(() => {
        notificationElement.remove()
        this.updateCounter()
        this.updateUnreadIndicator()
      }).catch(error => {
      })
    }
  }

  handleLinkClick(event) {
    event.stopPropagation()
    
    const notificationElement = event.target.closest('.O_Notification')
    const notificationId = notificationElement.dataset.notificationId
    
    if (notificationId) {
      fetch(`/notifications/${notificationId}/mark_read`, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        }
      }).then(() => {
        notificationElement.remove()
        this.updateCounter()
        this.updateUnreadIndicator()
      }).catch(error => {
      })
    }
  }

  updateCounter() {
    const unreadNotifications = this.listTarget.querySelectorAll('.O_Notification')
    const counter = this.counterTarget
    counter.textContent = unreadNotifications.length
  }

  updateUnreadIndicator() {
    const counter = this.counterTarget
    const count = parseInt(counter.textContent) || 0
    
    if (count === 0) {
      this.buttonTarget.classList.remove("has-unread")
    } else {
      this.buttonTarget.classList.add("has-unread")
    }
  }
}
