import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";
import {Calendar} from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid';
import allLocales from '@fullcalendar/core/locales-all';
import Swal from 'sweetalert2';

export default class extends Controller {
  static targets = ['calendar']

  connect() {
    if (this.hasCalendarTarget) {
      var calendar = this.Calendar();
      calendar.render();
    }
  }

  Calendar(target = this.calendarTarget) {
    var cal, url;

    url = target.dataset.calendarUrl;
    cal = new Calendar(target, {
      plugins: [interactionPlugin, dayGridPlugin],
      selectable: target.classList.contains('editable'),
      editable: target.classList.contains('editable'),
      aspectRatio: 1.5,
      locales: allLocales,
      locale: document.getElementsByTagName('html')[0].lang,
      events: `${url}/agenda.json`,
      eventClick: (info) => {
        info.jsEvent.preventDefault();
        if (info.event.url) {
          url = info.event.url;
          return Rails.ajax({
            type: "GET",
            url: `${url}/modifica`,
            success: (response, status, xhr) => {
              this.send(xhr.response);
            },
            error: (error) => {
              return this.send("Si è verificato un errore durante il caricamento! Si prega di provare più tardi.", "error");
            }
          });
        }
      }
    });
    return cal;
  }

  reload(event) {
    var calendar;

    if (this.hasCalendarTarget) {
      calendar = this.calendarTarget;
    } else {
      calendar = document.getElementById('calendar');
    }
    calendar.innerHTML = '';
    calendar = this.Calendar(calendar);
    return calendar.render();
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
  }

}