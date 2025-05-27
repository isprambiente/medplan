import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import Swal from 'sweetalert2';

export default class extends Controller {
  static targets = ["container"];

  async renderUser(event, user_id = "") {
    let target, container;

    if (!user_id) {
      target = event.currentTarget;
      user_id = target.dataset.userId;
    }

    container = document.getElementById(`user_${user_id}`);

    try {
      const response = await get(`/utenti/${user_id}/utente`);
      if (!response.ok) throw new Error("Errore nella richiesta");

      if (container) {
        container.outerHTML = await response.text();
      }
    } catch (error) {
      this.send("Si è verificato un errore durante il caricamento! Si prega di provare più tardi.", "error");
    }
  }

  edit(event) {
    var btnCanc, btnSave, buttons, container, editDiv, el, form, i, len, oldDate, opt, option, option_splitted, options, target, userId, user_id;

    target = event.target;
    if (target.classList.contains('editable')) {
      container = target.parentNode;
      userId = target.dataset.userId;
      editDiv = document.createElement("DIV");
      editDiv.id = `${userId}_editor`;
      editDiv.className = "editor";
      container.appendChild(editDiv);
      oldDate = target.text;
      if (target.dataset.hasOwnProperty('fieldType')) {
        if (target.dataset.fieldType === 'textarea') {
          el = document.createElement("TEXTAREA");
          el.className = "textarea editor is-radiusless";
          el.style = 'width:80%;';
          el.innerHTML = target.dataset.fieldValue;
        } else if (target.dataset.fieldType === 'select') {
          el = document.createElement("SELECT");
          el.className = "select editor is-radiusless";
          el.style = "width:60%;";
          options = target.dataset.fieldOptions.split(',');
          if (target.dataset.fieldPrompt) {
            opt = document.createElement("option");
            opt.value = "";
            opt.text = target.dataset.fieldPrompt;
            if (target.dataset.fieldValue === "") {
              opt.selected = true;
            }
            el.appendChild(opt);
          }
          for (i = 0, len = options.length; i < len; i++) {
            option = options[i];
            opt = document.createElement("option");
            if (option.indexOf("||") >= 0) {
              option_splitted = option.split("||");
              opt.value = option_splitted[0];
              opt.text = option_splitted[1];
            } else {
              opt.value = option;
              opt.text = option;
            }
            if (option === target.dataset.fieldValue) {
              opt.selected = true;
            }
            el.appendChild(opt);
          }
        } else if (target.dataset.fieldType === 'file') {
          user_id = target.dataset.userId;
          form = document.createElement("FORM");
          form.method = 'post';
          form.action = `/utenti/${user_id}`;
          form.dataset.multipart = 'true';
          form.dataset.remote = '';
          form.acceptCharset = 'UTF-8';
          form.dataset.action = 'users';
          form.dataset.controller = "users";
          form.dataset.action = 'ajax:success->users#abort';
          el = document.createElement("INPUT");
          el.type = 'hidden';
          el.name = '_method';
          el.value = 'put';
          form.appendChild(el);
          el = document.createElement("INPUT");
          el.name = target.dataset.fieldName;
          el.type = target.dataset.fieldType;
          el.className = `input ${target.dataset.fieldType} editor is-radiusless`;
          el.style = "width:60%;";
          el.accept = target.dataset.fieldAccept || '';
          // el.dataset.directUpload = target.dataset.fieldDirectUpload || 'false'
          form.appendChild(el);
        } else {
          el = document.createElement("INPUT");
          el.type = target.dataset.fieldType;
          el.className = `input ${target.dataset.fieldType} editor is-radiusless`;
          el.style = "width:60%;";
          el.value = target.dataset.fieldValue;
        }
      } else {
        el = document.createElement("INPUT");
        el.className = "input editor is-radiusless";
        el.style = "width:60%;";
        el.value = target.dataset.fieldValue;
      }
      if (target.dataset.hasOwnProperty('fieldPattern')) {
        el.pattern = target.dataset.fieldPattern;
        el.addEventListener('change', (event) => {
          if (el.validity.typeMismatch) {
            return el.setCustomValidity("Valore inserito non valido!");
          } else {
            return el.setCustomValidity("");
          }
        });
      }
      if (target.dataset.hasOwnProperty('fieldRequired')) {
        el.required = 'required';
      }
      if (target.dataset.fieldType !== 'file') {
        el.placeholder = target.dataset.fieldPlaceholder;
        el.name = target.dataset.fieldName;
        editDiv.appendChild(el);
        btnSave = document.createElement("BUTTON");
        btnSave.innerHTML = `<i class='fa fa-save' style=${target.dataset.fieldType === 'textarea' ? '' : 'padding-right:0px'}></i>${target.dataset.fieldType === 'textarea' ? ' Salva' : ''}`;
        btnSave.className = "button tooltip is-transparent is-borderless is-radiusless";
        btnSave.dataset.tooltip = "Salva";
        btnSave.dataset.controller = "users";
        btnSave.dataset.action = "click->users#update";
        btnSave.dataset.userId = userId;
        editDiv.appendChild(btnSave);
        btnCanc = document.createElement("BUTTON");
        btnCanc.innerHTML = `<i class='fa fa-times' style=${target.dataset.fieldType === 'textarea' ? '' : 'padding-right:0px'}></i>${target.dataset.fieldType === 'textarea' ? ' Annulla' : ''}`;
        btnCanc.className = "button tooltip is-transparent is-borderless is-radiusless";
        btnCanc.dataset.tooltip = "Annulla";
        btnCanc.dataset.controller = "users";
        btnCanc.dataset.action = "click->users#abort";
        editDiv.appendChild(btnCanc);
      } else {
        if (form) {
          buttons = document.createElement("DIV");
          buttons.className = 'buttons';
          btnSave = document.createElement("BUTTON");
          btnSave.innerHTML = `<i class='fa fa-save' style=${target.dataset.fieldType === 'textarea' ? '' : 'padding-right:0px'}></i>${target.dataset.fieldType === 'textarea' ? ' Salva' : ''}`;
          btnSave.className = "button tooltip is-transparent is-borderless is-radiusless";
          btnSave.dataset.tooltip = "Salva";
          btnSave.type = 'submit';
          btnSave.dataset.userId = userId;
          buttons.appendChild(btnSave);
          btnCanc = document.createElement("BUTTON");
          btnCanc.innerHTML = `<i class='fa fa-times' style=${target.dataset.fieldType === 'textarea' ? '' : 'padding-right:0px'}></i>${target.dataset.fieldType === 'textarea' ? ' Annulla' : ''}`;
          btnCanc.className = "button tooltip is-transparent is-borderless is-radiusless";
          btnCanc.dataset.tooltip = "Annulla";
          btnCanc.dataset.controller = "users";
          btnCanc.dataset.action = "click->users#abort";
          buttons.appendChild(btnCanc);
          form.appendChild(buttons);
          editDiv.appendChild(form);
        }
      }
      return target.classList.add('is-hidden');
    }
  }

  update(event) {
    var container, editor, input, link, target, url, user_id, value;

    target = event.currentTarget;
    editor = target.parentNode;
    container = editor.parentNode;
    link = container.querySelector(".editable");
    input = editor.querySelector(".editor");
    value = input.value;
    user_id = target.dataset.userId;
    url = `/utenti/${user_id}`;
    if (input.checkValidity()) {
      return Rails.ajax({
        type: "PUT",
        url: `${url}`,
        data: `${input.name}=${value}`,
        success: (data, status, xhr) => {
          this.send('Salvataggio avvenuto correttamente!');
          this.removeElement(target);
          if (link.dataset.fieldType === 'date') {
            value = new Date(value).toLocaleDateString(window.navigator.language || 'it', {
              day: '2-digit',
              month: '2-digit',
              year: 'numeric'
            });
          } else if (link.dataset.fieldType === 'password') {
            value = '*********';
          }
          return link.innerHTML = value !== '' ? value : (link.dataset.fieldPlaceholder ? link.dataset.fieldPlaceholder : 'aggiungi');
        },
        error: (error) => {
          var text;
          text = error;
          try {
            text = text.error;
          } catch (error1) {}
          if (text) {
            this.send(text, 'error');
          } else {
            this.send('Si è verificato un errore durante il salvataggio!', 'error');
          }
          return this.removeElement(target);
        }
      });
    } else {
      if (input.hasAttribute('pattern')) {
        return this.send(`Immettere un valore compreso tra ${input.pattern}!`, 'error');
      } else {
        return this.send('Valore immesso non valido!', 'error');
      }
    }
  }

  abort(event) {

    return this.removeElement(event.currentTarget);
  }

  removeElement(target) {
    var container, editor, link;

    if (target.closest('.editor')) {
      editor = target.closest('.editor');
      container = editor.parentNode;
      editor.remove();
      if (container) {
        link = container.querySelector('.editable.is-hidden');
      }
      if (link) {
        return link.classList.remove('is-hidden');
      }
    }
  }

  send(message, level = 'success', force = false, timeout = 2000, toast = true) {
    var options;
    options = {
      toast: level === 'error' ? false : toast,
      icon: level,
      timerProgressBar: true,
      position: level === 'error' ? 'center' : 'top-end',
      text: message,
      timer: level === 'error' ? false : timeout,
      showConfirmButton: level === 'error' ? true : false,
      didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer);
        return toast.addEventListener('mouseleave', Swal.resumeTimer);
      },
      showClass: {
        popup: level === 'error' ? '' : 'animate__animated animate__bounceInRight'
      },
      hideClass: {
        popup: level === 'error' ? '' : 'animate__animated animate__bounceOutRight'
      }
    };
    if (Swal.isVisible() && force == 'true') {
      Swal.fire(options);
    } else if (!Swal.isVisible()) {
      Swal.fire(options);
    }
  }
}
