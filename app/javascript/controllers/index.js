// Load all the controllers within this directory and all subdirectories.
// Controller files must be named *_controller.js.
// ./bin/rails generate stimulus controllerName

import { application } from "./application"
import { AttachmentUpload } from "@rails/actiontext/app/javascript/actiontext/attachment_upload"

import controllers from "./**/*_controller.js"
controllers.forEach((controller) => {
  application.register(controller.name, controller.module.default)
})

addEventListener("trix-attachment-add", event => {
  const { attachment, target } = event
  if (attachment.file) {
    const upload = new AttachmentUpload(attachment, target)
    upload.start()
  }
})
