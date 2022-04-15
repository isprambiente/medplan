import { Controller } from "@hotwired/stimulus";
import {Calendar} from '@fullcalendar/core';
import interactionPlugin from '@fullcalendar/interaction';
import dayGridPlugin from '@fullcalendar/daygrid';
import allLocales from '@fullcalendar/core/locales-all';

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

    url = target.dataset.eventsUrl;
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
            url: `${url}/<%= I18n.t( 'edit', scope: 'routes', default: 'edit' ) %>`,
            success: (response, status, xhr) => {
              var modal;
              modal = document.getElementById('modal');
              if (modal) {
                modal.querySelector('.modal-card-title').innerHTML = `${info.event.extendedProps.gender === 'visit' ? 'Visite' : 'Analisi'} a ${info.event.extendedProps.city} del ${info.event.extendedProps.date_on}`;
                modal.querySelector('.modal-card-body').innerHTML = xhr.response;
                modal.classList.add('is-active');
                return modal.closest('html').classList.add('is-clipped');
              }
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

  refreshCalendar(event) {
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


}