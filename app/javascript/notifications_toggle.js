// // app/javascript/packs/notifications_toggle.js
// document.addEventListener("DOMContentLoaded", () => {
//   // Кнопка с id="notifications"
//   const bell = document.getElementById("notifications")
//   // Панель с id="notificationsPanel"
//   const panel = document.getElementById("notificationsPanel")

//   if (!bell || !panel) return

//   // При клике на колокольчик переключаем класс .is-open у панели
//   bell.addEventListener("click", (e) => {
//     e.stopPropagation()
//     panel.classList.toggle("is-open")
//     // Если панель только что открылась — пометьте все уведомления как прочитанные
//     if (panel.classList.contains("is-open")) {
//       fetch("/notifications/mark_all_read", {
//         method: "POST",
//         headers: {
//           "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
//           "Content-Type": "application/json"
//         }
//       }).then(() => {
//         // Сбросим счётчик
//         const span = document.querySelector(".notificationsCounter span")
//         if (span) span.innerText = 0

//         // Уберём красную точку
//         bell.classList.remove("has-unread")

//         // Уберём фон у новых уведомлений
//         panel.querySelectorAll(".notification--new")
//              .forEach(elem => elem.classList.remove("notification--new"))
//       })
//     }
//   })

//   // Клик вне панели и вне кнопки -> закрываем панель
//   document.addEventListener("click", (e) => {
//     if (!panel.contains(e.target) && !bell.contains(e.target)) {
//       panel.classList.remove("is-open")
//     }
//   })
// })
