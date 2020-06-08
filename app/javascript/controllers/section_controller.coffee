import Rails from "@rails/ujs"
import PageController from './page_controller'
import Timeout from 'smart-timeout'

export default class extends PageController

  connect: =>
    if this.data.has("url")
      this.getPage(this.data.get('url'))

  sendForm: (event) =>
    Rails.fire(event.target.closest('form'), 'submit')

  delayedSendForm: (event) =>
    if  Timeout.exists('textDelay')
      Timeout.set( 'textDelay', true )
    Timeout.set('textDelay', (() => this.sendForm(event)), 750)
