// Import all the channels to be used by Action Cable
// обязательно импортируем в index.js все каналы, которые хотим слушать
import "./consumer"
import "./notifications_channel"
// (если у вас есть turbo_streams_channel.js – тоже его подключайте здесь, но главное: notifications_channel.js обязательно упомянут)
