import { Controller } from "@hotwired/stimulus";
import { FetchRequest, get, patch } from "@rails/request.js";
import moment from 'moment';
import Swal from 'sweetalert2';

export default class extends Controller {
  static targets = [ "container", "auditExpire" ]

  editDateExpire(event) {
    var btnCanc, btnSave, container, editDiv, el, oldDate, target;
    target = event.target;
    container = target.parentNode;
    editDiv = document.createElement("DIV");
    editDiv.id = `${container.id}_editor`;
    editDiv.className = "editor";
    container.appendChild(editDiv);
    oldDate = target.text;
    el = document.createElement("INPUT");
    el.type = "date";
    el.className = "input is-radiusless";
    el.style = "width:60%;";
    el.value = moment(oldDate, "DD/MM/YYYY").format("YYYY-MM-DD");
    editDiv.appendChild(el);
    btnSave = document.createElement("BUTTON");
    btnSave.innerHTML = "<i class='fa fa-save' style='padding-right:0px'></i>";
    btnSave.className = "button tooltip is-success is-radiusless";
    btnSave.dataset.tooltip = "Salva";
    btnSave.dataset.controller = 'audits';
    btnSave.dataset.action = "click->audits#updateDateExpire";
    btnSave.dataset.userId = target.dataset.userId;
    editDiv.appendChild(btnSave);
    btnCanc = document.createElement("BUTTON");
    btnCanc.innerHTML = "<i class='fa fa-times' style='padding-right:0px'></i>";
    btnCanc.className = "button tooltip is-danger is-radiusless";
    btnCanc.dataset.tooltip = "Annulla";
    btnCanc.dataset.controller = 'audits';
    btnCanc.dataset.action = "click->audits#abortDateExpire";
    editDiv.appendChild(btnCanc);
    return target.classList.add('is-hidden');
  }

  async updateDateExpire(event) {
    const target = event.currentTarget;
    const editor = target.parentNode;
    const container = editor.parentNode;
    const inputDate = container.querySelector("input[type=date]");
    const newDate = inputDate.value;
    const link = container.querySelector("a.expire_date");
    const url = link.dataset.auditsUrl;
    const user_id = target.dataset.userId;

    if (newDate !== "") {
      try {
        await patch(url, {
          body: JSON.stringify({ audit: { expire: newDate } }),
        });

        this.send("Salvataggio avvenuto correttamente!");
        this.removeElement(target);
        link.text = moment(newDate).format("DD/MM/YYYY");

        if (user_id) {
          let userContainer = document.getElementById(`user_${user_id}`);
          const response = await get(`/utenti/${user_id}/utente`);
          if (userContainer) {
            userContainer.outerHTML = await response.text;
          }
        }

        let td = document.getElementById(`td_audit_${user_id}`);
        if (container) {
          if (moment().diff(moment(newDate), "days") >= 1) {
            container.classList.add("expired");
            container.classList.remove("active");
            link.closest("td").classList.add("expired");
          } else {
            container.classList.add("active");
            container.classList.remove("expired");
            link.closest("td").classList.remove("expired");
          }
        }
      } catch (error) {
        this.send("Si è verificato un errore durante il salvataggio della data!", "error");
      }
    }
  }

  abortDateExpire(event) {
    var target;
    target = event.currentTarget;
    return this.removeElement(target);
  }

  removeElement(target) {
    var container, editor, link;
    editor = target.parentNode;
    container = editor.parentNode;
    editor.remove();
    link = container.querySelector('a.is-hidden');
    if (link) {
      return link.classList.remove('is-hidden');
    }
  }

  async manageAudit(event) {
    const target = event.currentTarget;
    const url = target.dataset.auditsUrl;
    const method = target.dataset.auditsMethod;
    const user_id = target.dataset.userId;

    try {
      const request = new FetchRequest(method, url);
      const response = await request.perform();

      if (!response.ok) {
        throw new Error("Errore nella richiesta");
      }

      target.closest(".columns").outerHTML = await response.text;

      if (user_id) {
        const element = document.getElementById(`user_${user_id}`);
        const userRequest = new FetchRequest("GET", `/utenti/${user_id}/utente`);
        const userResponse = await userRequest.perform();

        if (element) {
          element.outerHTML = await userResponse.text;
        }
      }

      this.send("Salvataggio avvenuto correttamente!");
    } catch (error) {
      this.send("Si è verificato un errore durante il salvataggio!", "error");
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
