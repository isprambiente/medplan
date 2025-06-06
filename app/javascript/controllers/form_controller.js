import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import Timeout from 'smart-timeout';
import Swal from 'sweetalert2';
import DualListbox from 'dual-listbox/dist/dual-listbox';

export default class extends Controller {
  static targets = ['listbox']
  static values = {
    details: { type: String, default: 'info' },
    status: { type: String, default: 'close' }
  }

  connect() {
    // Per disattivare l'evento click dei bottoni dopo il passaggio a Bulma
    // che non ha la gestione eventi via Javascript
    document.querySelectorAll('[disabled]').forEach(function(obj) {
      return obj.classList.add('is-disabled');
    });
    if (this.hasListboxTarget) {
      const select = this.listboxTarget;
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
    const form = event.target.closest('form');
    if (form) {
      form.requestSubmit();
    }
  }

  delayedSend(event) {
    if (Timeout.exists('textDelay'))
      Timeout.set('textDelay', true);
    return Timeout.set('textDelay', (() => {
      return this.send(event);
    }), 750);
  }

  reset(event) {
    event.target.closest("form").reset();
  }

  close() {
    if (Swal.isVisible())
      return Swal.close();
  }

  toggleVisible(event) {
    document.getElementById(event.currentTarget.dataset.id).classList.toggle('is-hidden');
    if (event.currentTarget.querySelector('i.fas'))
      return event.currentTarget.querySelector('i.fas').classList.toggle('fa-chevron-down');
  }

  details(event) {
    const target = document.getElementById(this.detailsValue);
    const button = event.target;
    this.statusValue = this.statusValue === 'close' ? 'open' : 'close';

    target?.classList.toggle('is-hidden');

    const icon = button.closest('a')?.querySelector('[data-icon]');
    if (icon) {
      const icons = ['circle-plus', 'circle-minus'];
      icon.dataset.icon = icons.find(i => i !== icon.dataset.icon);
    }
  }

  async sendValue(event) {
    const target = event.target;
    const url = target.dataset.formUrl;
    const param_data = new URLSearchParams({ [target.name]: target.value });

    try {
      const response = await get(`${url}?${param_data}`);

      if (!response.ok)
        throw new Error("Errore nella richiesta");

      target.closest(".container").outerHTML = await response.text;
    } catch (error) {
      console.error("Si è verificato un errore:", error);
    }
  }

  focus(event) {
    if (event.currentTarget.dataset.formId) {
      const target = document.getElementById(event.currentTarget.dataset.formId);
      if (target)
        return target.scrollIntoView();
    }
  }

  async confirmation(event) {
    const target = event.target;
    const confirmation = target.dataset.formConfirmation || '';
    const url = target.dataset.formUrl;
    const icon = target.dataset.icon || 'question';
    const title = target.dataset.title || '';
    const deletable = target.dataset.deletable || false;
    const form = target.closest('form');
    const options = {
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
    const result = await Swal.fire(options);
    if (result.isConfirmed)
      return window.location.href = url;
  }

  confirm_before_send(event) {
    const target = event.currentTarget;
    if (target.dataset.force !== 'true') {
      event.preventDefault();
      event.stopPropagation();
      const icon = target.dataset.icon || 'question';
      const title = target.dataset.title || '';
      const confirmation = target.dataset.confirmation;
      const deletable = target.dataset.deletable || false;
      const form = target.closest('form');
      const options = {
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
            if (deletable)
              this.removeRow(event);
            return this.send(event);
          }
        }
      });
    }
  }
}
