import { Controller } from "@hotwired/stimulus";
import Rails from '@rails/ujs';
import Timeout from 'smart-timeout';
import SlimSelect from 'slim-select';
import Swal from 'sweetalert2';
import DualListbox from 'dual-listbox/dist/dual-listbox';

export default class extends Controller {
  static targets = ['slimselect', 'listbox']

  connect() {
    // Per disattivare l'evento click dei bottoni dopo il passaggio a Bulma
    // che non ha la gestione eventi via Javascript
    document.querySelectorAll('[disabled]').forEach(function(obj) {
      return obj.classList.add('is-disabled');
    });
    if (this.hasSlimselectTarget) {
      return this.slimselectTargets.forEach((slim) => {
        return this.slimSelect(slim);
      });
    }
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

  getSlimSelect(container) {
    var slimselects;
    slimselects = container.querySelectorAll('.slimselect');
    if (slimselects) {
      return slimselects.forEach(function(slim) {
        return this.slimselect(slim);
      });
    }
  }

  toggleSelect(event) {
    if (this.hasSlimselectTarget) {
      if (this.slimselectTarget.querySelector('.ss-main') !== null) {
        this.slimselectTarget.querySelector('.ss-main').remove();
        this.slimselectTarget.querySelector('select').classList.remove('is-hidden');
        this.slimselectTarget.querySelector('select').removeAttribute('style');
      }
      this.slimselectTarget.classList.toggle('is-hidden');
      return this.slimSelect(this.slimselectTarget.querySelector('select'));
    }
  }

  slimSelect(select) {
    var slim;
    if (select.dataset.formAddable === 'true') {
      var url = ((select.dataset.formLink == undefined) ? '' : select.dataset.formLink);
      var field = ((select.dataset.formField == undefined) ? '' : select.dataset.formField);
      var opened = ((select.dataset.formLeaveOpened === 'true') ? false : true)
      return slim = new SlimSelect({
        addToBody: true,
        closeOnSelect: opened,
        select: `#${select.id}`,
        searchingText: 'Ricerca in corso...',
        searchText: 'Nessun record trovato',
        searchPlaceholder: 'Cerca',
        placeholder: 'Seleziona uno o più valori',
        text: 'Seleziona uno o più valori',
        addable: (value) => {
          var displayData;
          displayData = [];
          if (value === '') {
            return this.send('Inserire un valore prima di cliccare sul bottone', 'error');
          } else if (value != '' && url == '') {
            return value;
          } else if (url !='' && confirm(`Stai per inserire '${value}' nel sistema, confermi di voler proseguire?`)) {
            return Rails.ajax({
              type: 'PUT',
              url: url,
              data: `${field}=${value}`,
              success: (data, status, xhr) => {
                var response;
                response = xhr.response;
                data = JSON.parse(response);
                slim.setData(data.rows);
                slim.set(data.id);
                this.send(`Inserimento del valore ${value} avvenuto con successo!`);
                return true;
              },
              error: (data, status, xhr) => {
                var response;
                response = xhr.response;
                data = JSON.parse(response);
                this.send(data.error, 'error');
                return false;
              }
            });
          }
        }
      });
    } else {
      return slim = new SlimSelect({
        addToBody: true,
        select: `#${select.id}`,
        searchingText: 'Ricerca in corso...',
        searchText: 'Nessun record trovato',
        searchPlaceholder: 'Cerca',
        placeholder: 'Seleziona uno o più valori',
        text: 'Seleziona uno o più valori'
      });
    }
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
