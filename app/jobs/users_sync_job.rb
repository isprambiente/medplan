# frozen_string_literal: true

# This job contain the methods for sync users with REST-API json
class UsersSyncJob < ApplicationJob
  queue_as :urgent
  require "open-uri"

  # get users data from remote api.
  # For each user received run {set_data}
  # get users data from remote api.
  # For each user received run {set_data}
  def perform(codicefiscale: "")
    url = Rails.application.credentials.api[:url] || Settings.api.url.to_s
    return if url.blank?

    users = User.unscoped.order(label: :asc)
    users = users.where(cf: codicefiscale.upcase) if codicefiscale.present?
    uri = URI.parse(url)
    opts = {
      http_basic_authentication: [
        Rails.application.credentials.api[:user] || Settings.api.username.to_s,
        Rails.application.credentials.api[:secret_access_key] || Settings.api.secret_access_key.to_s
      ],
      ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    users.each do |user|
      next if user.cf.blank?

      uri.query = "codicefiscale=#{user.cf}"
      begin
        json_data = URI.parse(uri.to_s).open(opts).read
      rescue
        puts "No connection"
      else
        if json_data
          user_data = JSON.parse(json_data)
          user_data = user_data.first if user_data.is_a?(Array)
          set_data(user, user_data)
        end
      ensure
        uri.query = ""
      end
    end
  end

  # update a user with api data
  # @param [Object] user istance of user to update
  # @param [Hash] data all user's data from the api. Default: {}
  # @return [Boolean] true if user is updated
  def set_data(user, data = {})
    return if data.blank?

    user.username                 = "#{ data["login"] }#{ ENV.fetch("RAILS_EMAIL_DOMAIN", "@domain.com") }" if user.username.blank? && data["login"].present?
    user.label                    = data["nominativo"]
    user.lastname                 = data["cognome"]
    user.name                     = data["nome"]
    user.cf                       = data["cf"]
    user.email                    = data["email"]
    user.sex                      = data["sesso"]
    user.matr                     = data["matricola"]
    user.status                   = data["stato"]
    user.data_nasc                = data["anagrafica"]["data"]

    user.citta_nasc               = data["anagrafica"]["comune"]
    user.naz_nasc                 = data["anagrafica"]["nazione"]
    user.scadenza_rapporto        = data["contratto"]["fine"]
    user.tipo_contratto           = data["contratto"]["tipo"]
    user.denominazione_contratto  = data["contratto"]["denominazione"]
    user.location                 = if data["rubrica"]["sede"]["denominazione"].present?
                                      data["rubrica"]["sede"]["denominazione"]
    elsif data["rubrica"]["jpers"]["denominazione"].present?
                                      data["rubrica"]["jpers"]["denominazione"]
    else
                                      ""
    end
    user.city                     = if data["rubrica"]["sede"]["citta"].present? && data["rubrica"]["sede"]["citta"].try(:downcase) != "other"
                                      data["rubrica"]["sede"]["citta"].try(:downcase)
    elsif data["rubrica"]["jpers"]["citta"].present?
                                      data["rubrica"]["jpers"]["citta"].try(:downcase)
    else
                                      "other"
    end
    user.floor                    = data["rubrica"]["piano"]
    user.room                     = data["rubrica"]["stanza"]
    user.telephone                = data["rubrica"]["interno"]
    user.emergenze                = data["rubrica"]["emergenze"]
    user.structure                = data["struttura"]["ufficio"]["sigla"]
    user.structure_label          = data["struttura"]["ufficio"]["denominazione"]
    user.responsabile             = data["struttura"]["ufficio"]["responsabile"]["nominativi"]
    user.postazione               = data["postazione"]["tipo"]
    user.postazione_inizio        = data["postazione"]["inizio"]
    user.postazione_fine          = data["postazione"]["fine"]
    user.postazione_locazione     = data["postazione"]["locazione"]
    user.postazione_created_at    = data["postazione"]["created_at"]
    user.postazione_updated_at    = data["postazione"]["updated_at"]
    user.data_aggiornamento       = data["updated_at"]
    user.deleted                  = data["stato"] == "scaduto"
    user.prefix                   = Settings.users.tel_prefix
    response = user.save

    Rails.logger.debug "#{user.username} - #{response}" unless response
  end
end
