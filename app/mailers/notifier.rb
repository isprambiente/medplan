# frozen_string_literal: true

# This notifier contain the methods shared for all app
# Defaul sender are loaded from config/settings.yml - email
class Notifier < ApplicationMailer
  # this method notifies the user a new event
  # @param [Object] user it is the user to be notified
  def user_event(user)
    @user = user

    mail(to: @user.email, subject: t('user_event', scope: 'message.email.subjects')) if @user.email.present?
  end

  # this method notifies the user a new analisy event
  # @param [Object] user it is the user to be notified
  def user_event_analisys(user)
    @user = user

    mail(to: @user.email, subject: t('user_event_analisys', scope: 'message.email.subjects')) if @user.email.present?
  end

  # this method notifies the user a new visit event
  # @param [Object] user it is the user to be notified
  def user_event_visit(user)
    @user = user

    mail(to: @user.email, subject: t('user_event_visit', scope: 'message.email.subjects')) if @user.email.present?
  end

  # this method notifies the user a new event
  # @param [Object] user it is the user to be notified
  # @param [Object] event it is the related event
  def user_event_confirmed(user, event)
    @user = user
    @event = event
    meeting = user.meetings.find_by(event: event)
    attachments.inline['prenotazione.ics'] = meeting.ical.to_ical if meeting.confirmed?
    mail(to: @user.email, subject: t('user_event_modified', scope: 'message.email.subjects') + ' ' + (l event.date_on)) if user.email.present?
  end
end
