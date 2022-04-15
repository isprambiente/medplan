import { Controller } from "@hotwired/stimulus";
import Swal from 'sweetalert2';

export default class extends Controller {

  connect() {
    var body;
    body = this.element.innerHTML;
    if (body) {
      this.send(body);
    }
    return this.element.outerHTML = '';
  }

  close() {
    if (Swal.isVisible()) {
      return Swal.close();
    }
  }

  disconnect() {
    return this.outerHTML = '';
  }

  send(body = '') {
    var options;
    options = {
      width: '70%',
      heightAuto: true,
      height: true,
      toast: false,
      icon: false,
      timerProgressBar: false,
      position: 'center',
      title: false,
      html: body,
      footer: false,
      timer: false,
      showConfirmButton: false,
      showCloseButton: true,
      showCancelButton: false,
      cancelButtonText: "Chiudi",
      showClass: {
        popup: 'animated fadeIn'
      },
      hideClass: {
        popup: ''
      }
    };
    if (Swal.isVisible()) {
      Swal.update(options);
    } else {
      Swal.fire(options);
    }
    if (Swal.getPopup().querySelector('.is-formula')) {
      return MathJax.typeset();
    }
  }

}
