import { Controller } from '@hotwired/stimulus';

export default class extends Controller {

  focus(event) {
    var target;
    if (event.currentTarget.dataset.bookId) {
      target = document.getElementById(event.currentTarget.dataset.bookId);
      if (target) {
        return target.scrollIntoView();
      }
    }
  }
}