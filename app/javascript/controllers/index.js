import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import NotificationsController from "./notifications_controller"
application.register("notifications", NotificationsController)

