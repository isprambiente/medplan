import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";
import moment from 'moment';

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
    btnSave.dataset.action = "click->audits#updateDateExpire";
    btnSave.dataset.userId = target.dataset.userId;
    editDiv.appendChild(btnSave);
    btnCanc = document.createElement("BUTTON");
    btnCanc.innerHTML = "<i class='fa fa-times' style='padding-right:0px'></i>";
    btnCanc.className = "button tooltip is-danger is-radiusless";
    btnCanc.dataset.tooltip = "Annulla";
    btnCanc.dataset.action = "click->audits#abortDateExpire";
    editDiv.appendChild(btnCanc);
    return target.classList.add('is-hidden');
  }

  updateDateExpire(event) {
    var container, editor, inputDate, link, newDate, target, url, user_id;
    target = event.currentTarget;
    editor = target.parentNode;
    container = editor.parentNode;
    inputDate = container.querySelector("input[type=date]");
    newDate = inputDate.value;
    link = container.querySelector("a.expire_date");
    url = link.dataset.auditsUrl;
    user_id = target.dataset.userId;
    if (newDate !== '') {
      return Rails.ajax({
        type: "PATCH",
        url: `${url}`,
        data: `audit[expire]=${newDate}`,
        success: (data, status, xhr) => {
          var td;
          this.send('Salvataggio avvenuto correttamente!');
          this.removeElement(target);
          link.text = moment(newDate).format("DD/MM/YYYY");
          if (user_id) {
            container = document.getElementById(`user_${user_id}`);
            Rails.ajax({
              type: "GET",
              url: `/<%= I18n.t( 'users', scope: 'routes', default: 'users' ) %>/${user_id}/<%= I18n.t( 'user', scope: 'routes', default: 'user' ) %>`,
              success: (response, status, xhr) => {
                if (container) {
                  return container.outerHTML = xhr.response;
                }
              }
            });
          }
          td = document.getElementById(`td_audit_${user_id}`);
          if (container) {
            if (moment().diff(moment(newDate), 'days') >= 1) {
              container.classList.add('expired');
              container.classList.remove('active');
              return link.closest("td").classList.add('expired');
            } else {
              container.classList.add('active');
              container.classList.remove('expired');
              return link.closest("td").classList.remove('expired');
            }
          }
        },
        error: (error) => {
          return this.send('Si è verificato un errore durante il salvataggio della data!', 'error');
        }
      });
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

  manageAudit(event) {
    var method, target, url, user_id;
    target = event.currentTarget;
    url = target.dataset.auditsUrl;
    method = target.dataset.auditsMethod;
    user_id = target.dataset.userId;
    return Rails.ajax({
      type: `${method}`,
      url: `${url}`,
      success: (data, status, xhr) => {
        var element;
        target.closest('.columns').outerHTML = xhr.response;
        if (user_id) {
          element = document.getElementById(`user_${user_id}`);
          url = `/<%= I18n.t( 'users', scope: 'routes', default: 'users' ) %>/${user_id}/<%= I18n.t( 'user', scope: 'routes', default: 'user' ) %>`;
          this.getElement(element, url);
        }
        return this.send('Salvataggio avvenuto correttamente!');
      },
      error: (error) => {
        return this.send('Si è verificato un errore durante il salvataggio!', 'error');
      }
    });
  }

}
