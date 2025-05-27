import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import { Calendar } from '@fullcalendar/core';
import allLocales from '@fullcalendar/core/locales-all';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid';
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
    const url = target.dataset.calendarUrl;

    const cal = new Calendar(target, {
      plugins: [interactionPlugin, dayGridPlugin],
      selectable: target.classList.contains("editable"),
      editable: target.classList.contains("editable"),
      aspectRatio: 1.5,
      locales: allLocales,
      locale: document.documentElement.lang,
      events: `${url}/agenda.json`,
      eventClick: async (info) => {
        info.jsEvent.preventDefault();
        if (info.event.url) {
          try {
            const response = await get(`${info.event.url}/modifica`);
            if (!response.ok) throw new Error("Errore nella richiesta");
            this.send(await response.text());
          } catch (error) {
            this.send("Si è verificato un errore durante il caricamento! Si prega di provare più tardi.", "error");
          }
        }
      },
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