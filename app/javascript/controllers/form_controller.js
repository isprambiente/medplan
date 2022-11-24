import { Controller } from "@hotwired/stimulus";
import Rails from '@rails/ujs';
import Timeout from 'smart-timeout';
import Swal from 'sweetalert2';
import DualListbox from 'dual-listbox/src/dual-listbox';

export default class extends Controller {
  static targets = ['listbox']

  connect() {
    // Per disattivare l'evento click dei bottoni dopo il passaggio a Bulma
    // che non ha la gestione eventi via Javascript
    document.querySelectorAll('[disabled]').forEach(function(obj) {
      return obj.classList.add('is-disabled');
    });
    if (this.hasListboxTarget) {
      var select;
      select = this.listboxTarget;
      return new DualListbox(select, {
        availableTitle: 'Categorie disponibili',
        selectedTitle: 'Categorie selezionate',
        addButtonText: '>',
        removeButtonText: '<',
        addAllButtonText: '>>',
        removeAllButtonText: '<<'
      });
    }
  }

  send(event) {
    return Rails.fire(event.target.closest('form'), 'submit');
  }

  delayedSend(event) {
    if (Timeout.exists('textDelay')) {
      Timeout.set('textDelay', true);
    }
    return Timeout.set('textDelay', (() => {
      return this.send(event);
    }), 750);
  }

  reset(event) {
    return Rails.fire(event.target.closest('form'), 'reset');
  }

  close() {
    if (Swal.isVisible()) {
      return Swal.close();
    }
  }

  toggleVisible(event) {
    document.getElementById(event.currentTarget.dataset.id).classList.toggle('is-hidden');
    if (event.currentTarget.querySelector('i.fas')) {
      return event.currentTarget.querySelector('i.fas').classList.toggle('fa-chevron-down');
    }
  }

  details(event) {
    var target, icon, container, info;

    target = event.currentTarget;
    if (target) {
      container = target.closest('.event')
      if (container) {
        info = container.querySelector('span.info');
        if (info) {
          status = target.dataset.status;
          console.log(status);
          if (status == 'close') {
            icon = target.querySelector('.fa-circle-plus')
            if (icon) {
              icon.classList.add('fa-circle-minus');
              icon.classList.remove('fa-circle-plus');
            }
            info.classList.remove('is-hidden');
            target.dataset.status = 'open';
          } else {
            icon = target.querySelector('.fa-circle-minus')
            if (icon) {
              icon.classList.add('fa-circle-plus');
              icon.classList.remove('fa-circle-minus');
            }
            info.classList.add('is-hidden');
            target.dataset.status = 'close'
          }
        }
      }
    }
  }

  sendValue(event) {
    var param_data, target, url;
    target = event.target;
    url = target.dataset.formUrl;
    param_data = `${target.name}=${target.value}`;
    return Rails.ajax({
      type: 'GET',
      url: url,
      data: param_data,
      success: (data, status, xhr) => {
        return event.target.closest('.container').outerHTML = xhr.response;
      }
    });
  }

  focus(event) {
    var target;
    if (event.currentTarget.dataset.formId) {
      target = document.getElementById(event.currentTarget.dataset.formId);
      if (target) {
        return target.scrollIntoView();
      }
    }
  }

  confirmation(event) {
    var confirmation, deletable, form, icon, options, target, title, url;
    target = event.target;
    confirmation = target.dataset.formConfirmation || '';
    url = target.dataset.formUrl;
    icon = target.dataset.icon || 'question';
    title = target.dataset.title || '';
    deletable = target.dataset.deletable || false;
    form = target.closest('form');
    options = {
      icon: icon,
      timerProgressBar: false,
      position: 'center',
      title: title,
      html: confirmation,
      showConfirmButton: true,
      showCancelButton: true,
      confirmButtonText: "Si",
      cancelButtonText: "No",
      showClass: {
        popup: 'swal2-noanimation'
      },
      hideClass: {
        popup: ''
      }
    };
    return Swal.fire(options).then((result) => {
      if (result.isConfirmed) {
        return window.location.href = url;
      }
    });
  }

  confirm_before_send(event) {
    var confirmation, deletable, form, icon, options, target, title;
    target = event.currentTarget;
    if (target.dataset.force !== 'true') {
      event.preventDefault();
      event.stopPropagation();
      icon = target.dataset.icon || 'question';
      title = target.dataset.title || '';
      confirmation = target.dataset.confirmation;
      deletable = target.dataset.deletable || false;
      form = target.closest('form');
      options = {
        icon: icon,
        timerProgressBar: false,
        position: 'center',
        title: title,
        html: confirmation,
        showConfirmButton: true,
        showCancelButton: true,
        confirmButtonText: "Si",
        cancelButtonText: "No",
        showClass: {
          popup: 'swal2-noanimation'
        },
        hideClass: {
          popup: ''
        }
      };
      return Swal.fire(options).then((result) => {
        if (result.isConfirmed) {
          if (form && form.nodeName === "FORM") {
            if (deletable) {
              this.removeRow(event);
            }
            return this.send(event);
          }
        }
      });
    }
  }
}
