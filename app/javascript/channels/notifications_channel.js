// app/javascript/channels/notifications_channel.js
import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log("NotificationsChannel connected")
  },

  disconnected() {
    console.log("NotificationsChannel disconnected")
  },

  received(data) {
    console.log("NotificationsChannel received:", data)
    // При получении данных (data = { body: "...", url: "/events/123#comment_45" })
    // мы вызываем Stimulus-методы внутри notifications_controller.js
    // Поэтому тут можно ничего не дублировать, если вы строите логику внутри Stimulus-контроллера.
    // Но поскольку Stimulus уже обрабатывает received(data), здесь может стоять просто console.log.
  }
})
