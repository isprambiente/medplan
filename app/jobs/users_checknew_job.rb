# frozen_string_literal: true

# This job contain the methods for sync users with REST-API json
class UsersChecknewJob < ApplicationJob
  queue_as :urgent
  require 'open-uri'

  # get users data from remote api.
  # For each user received run {set_data}
  def perform(*)
    json_parsed = JSON.parse(URI.open(
      URI.parse(Rails.application.credentials.api[:url] || Settings.api.url.to_s),
      http_basic_authentication: [
        Rails.application.credentials.api[:user] || Settings.api.username.to_s,
        Rails.application.credentials.api[:secret_access_key] || Settings.api.secret_access_key.to_s
      ],
      ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
    ).read)
    json_parsed.each do |user_data|
      if user_data['cf'].present?
        u = User.unscoped.find_or_initialize_by(cf: user_data['cf'].upcase)
        set_data(u, user_data) if u.username.present?
      end
    end
  end

  # update a user with api data
  # @param [Object] user istance of user to update
  # @param [Hash] data all user's data from the api. Default: {}
  # @return [Boolean] true if user is updated
  def set_data(user, data = {})
    return if data.blank?

    user.username                 = data['login'] if user.username.blank? && data['login'].present?
    user.label                    = data['nominativo']
    user.lastname                 = data['cognome']
    user.name                     = data['nome']
    user.cf                       = data['cf']
    user.email                    = data['email']
    user.sex                      = data['sesso']
    user.matr                     = data['matricola']
    user.status                   = data['stato']
    user.data_nasc                = data['anagrafica']['data']

    user.citta_nasc               = data['anagrafica']['comune']
    user.naz_nasc                 = data['anagrafica']['nazione']
    user.scadenza_rapporto        = data['contratto']['fine']
    user.tipo_contratto           = data['contratto']['tipo']
    user.denominazione_contratto  = data['contratto']['denominazione']
    user.location                 = if data['rubrica']['sede']['denominazione'].present?
                                      data['rubrica']['sede']['denominazione']
                                    elsif data['rubrica']['jpers']['denominazione'].present?
                                      data['rubrica']['sede']['denominazione']
                                    else
                                      ''
                                    end
    user.city                     = if data['rubrica']['sede']['citta'].present?
                                      data['rubrica']['sede']['citta'].try(:downcase)
                                    elsif data['rubrica']['jpers']['citta'].present?
                                      data['rubrica']['jpers']['citta'].try(:downcase)
                                    else
                                      'other'
                                    end
    user.floor                    = data['rubrica']['piano']
    user.room                     = data['rubrica']['stanza']
    user.telephone                = data['rubrica']['interno']
    user.emergenze                = data['rubrica']['emergenze']
    user.structure                = data['struttura']['ufficio']['sigla']
    user.structure_label          = data['struttura']['ufficio']['denominazione']
    user.responsabile             = data['struttura']['ufficio']['responsabile']['nominativi']
    user.postazione               = data['postazione']['tipo']
    user.postazione_inizio        = data['postazione']['inizio']
    user.postazione_fine          = data['postazione']['fine']
    user.postazione_locazione     = data['postazione']['locazione']
    user.postazione_created_at    = data['postazione']['created_at']
    user.postazione_updated_at    = data['postazione']['updated_at']
    user.data_aggiornamento       = data['updated_at']
    user.deleted                  = data['stato'] == 'scaduto'
    user.prefix                   = '065007'
    user.save
  end
end
