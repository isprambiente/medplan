import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  connect() {
    if (localStorage.getItem("cookie_consent")) {
      this.bannerTarget.remove()
    }
  }

  accept() {
    localStorage.setItem("cookie_consent", "accepted")
    this.bannerTarget.remove()
    // qui puoi attivare script di terze parti
  }

  reject() {
    localStorage.setItem("cookie_consent", "rejected")
    this.bannerTarget.remove()
  }
}