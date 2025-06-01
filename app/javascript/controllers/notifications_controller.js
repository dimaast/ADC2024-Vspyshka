// app/javascript/controllers/notifications_controller.js

import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["panel", "button", "counter", "list"]

  connect() {
    console.log("NotificationsController: connect")
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

    // Закрываем панель, если клик произошёл вне её области
    this._outsideClickHandler = this.closeIfClickedOutside.bind(this)
    window.addEventListener("click", this._outsideClickHandler)
  }

  disconnect() {
    if (this.subscription) {
      consumer.subscriptions.remove(this.subscription)
    }
    window.removeEventListener("click", this._outsideClickHandler)
  }

  toggle(event) {
    event.stopPropagation()

    const panel = this.panelTarget

    if (panel.hasAttribute("hidden")) {
      // Открываем панель
      panel.removeAttribute("hidden")
      panel.classList.add("is-open")
      this.buttonTarget.classList.add("is-active")

      // Отправляем запрос на пометку всех уведомлений как прочитанных
      fetch("/notifications/mark_all_read", {
        method: "POST",
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Content-Type": "application/json"
        }
      })
        .then(() => {
          // Обновляем счётчик и убираем красную точку
          this.counterTarget.textContent = "0"
          this.buttonTarget.classList.remove("has-unread")

          // Снимаем пометку «новое» у всех свежих уведомлений
          this.listTarget
            .querySelectorAll(".notification--new")
            .forEach(elem => elem.classList.remove("notification--new"))
        })
        .catch(err => console.error("Ошибка при mark_all_read:", err))
    } else {
      // Скрываем панель
      panel.setAttribute("hidden", "")
      panel.classList.remove("is-open")
      this.buttonTarget.classList.remove("is-active")
    }
  }

  closeIfClickedOutside(event) {
    if (
      this.hasPanelTarget &&
      !this.panelTarget.contains(event.target) &&
      !this.buttonTarget.contains(event.target)
    ) {
      this.panelTarget.setAttribute("hidden", "")
      this.panelTarget.classList.remove("is-open")
      this.buttonTarget.classList.remove("is-active")
    }
  }

  prependNotification(body, url) {
    console.log("prependNotification вызван с:", body, url)

    if (!this.hasListTarget) return

    const wrapper = document.createElement("div")
    wrapper.classList.add("notification", "notification--new")

    const link = document.createElement("a")
    link.href = url
    link.textContent = body
    wrapper.appendChild(link)

    // Добавляем в начало списка или, если нет ни одного элемента, просто вставляем
    const first = this.listTarget.querySelector(".notification")
    if (first) {
      this.listTarget.insertBefore(wrapper, first)
    } else {
      this.listTarget.appendChild(wrapper)
    }
  }

  incrementCounter() {
    if (!this.hasCounterTarget) return

    const span = this.counterTarget
    const current = parseInt(span.textContent, 10) || 0
    span.textContent = (current + 1).toString()
    this.buttonTarget.classList.add("has-unread")
  }
}
