import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  focus(event) {
    var target;
    if (event.currentTarget.dataset.sectionId) {
      target = document.getElementById(event.currentTarget.dataset.sectionId);
      if (target) {
        return target.scrollIntoView();
      }
    }
  }
}