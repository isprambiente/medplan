# frozen_string_literal: true

# === Relations
#
# * has many {Audit}
# * has many {Category}, through {Audit}
# * has many {Meeting}, through {Audit}
# * has many {Event}, through {Meeting}
# * has many {History}, through {Audit}
#
# === Validations
#
# * validate presence of {username}
# * validate uniqueness of {username}
# * validate presence of {label}
# * validate presence of {name}
# * validate presence of {lastname}
# * validate presence of {cf}
# * validate uniqueness of {cf}
# * validate presence of {postazione}
# * validate content type of {assegnazione} should be a pdf
# * validate size of {assegnazione}
#
# === Afteer update
# {check_disabled}
#
# === Before destroy
# {abort_destroy}
#
# @!attribute [rw] sign_in_count
#   @return [Integer] Counter of {User} sign in
# @!attribute [rw] current_sign_in_at
#   @return [DateTime] date of {User} current sign in
# @!attribute [rw] last_sign_in_at
#   @return [DateTime] date of {User} last sign in
# @!attribute [rw] current_sign_in_ip
#   @return [String] ip of {User} current sign in
# @!attribute [rw] last_sign_in_ip
#   @return [String] ip of {User} last sign in
# @!attribute [rw] locked_at
#   @return [Datetime] date when {User} was blocked
# @!attribute [rw] username
#   @return [String] unique {User} name
# @!attribute [rw] label
#   @return [String] long {User} name
# @!attribute [rw] city
#   Enum of cities
# @!attribute [rw] body
#   @return [String] note for {User}
# @!attribute [rw] secretary
#   @return [Boolean} true if {User} is a secretary otherwise false
# @!attribute [rw] doctor
#   @return [Boolean[ true if {User} is a doctor otherwise false
# @!attribute [rw] admin
#   @return [Boolean[ true if {User} is a admin otherwise false
# @!attribute [rw] created_at
#   @return [DateTime[ date when {User} was created
# @!attribute [rw] updated_at
#   @return [DateTime[ date when {User} was updated
# @!attribute [rw] deleted
#   @return [Boolean[ true if {User} was blocked from {secretary}
# @!attribute [rw] cf
#   @return [Strint[ {User}'s tax code
# @!attribute [rw] tel
#   @return [String[ {User}'s phone number
# @!attribute [rw] postazione
#   @return [String] enum of sites type
# @!attribute [rw] metadata
#   @return [Hash[ is a jsonb field for archive {User}'s details
# @!attribute [rw] email,
#   @return [String] {User}'s emails, is a store accessor of [metadata]
# @!attribute [rw] sex
#   @return [String] {User}'s sex type, is a store accessor of [metadata]
# @!attribute [rw] lastname
#   @return [String] {User}'s lastname, is a store accessor of [metadata]
# @!attribute [rw] name
#   @return [String] {User}'s name, is a store accessor of [metadata]
# @!attribute [rw] matr
#   @return [String] {User}'s work code, is a store accessor of [metadata]
# @!attribute [rw] status
#   @return [String] {User}'s status, is a store accessor of [metadata]
# @!attribute [rw] postazione_inizio
#   @return [String] when {postazione} was set, is a store accessor of [metadata]
# @!attribute [rw] postazione_fine
#   @return [String] when {postazione} end, is a store accessor of [metadata]
# @!attribute [rw] postazione_locazione
#   @return [String] {postazione} sites
# @!attribute [rw] postazione_created_at
#   @return [String] {User}'s when {postazione} was created, is a store accessor of [metadata]
# @!attribute [rw] postazione_updated_at
#   @return [String] {User}'s when {postazione} was updated, is a store accessor of [metadata]
# @!attribute [rw] data_nasc
#   @return [String] {User}'s born date, is a store accessor of [metadata]
# @!attribute [rw] citta_nasc
#   @return [String] {User}'s born city, is a store accessor of [metadata]
# @!attribute [rw] naz_nasc
#   @return [String] {User}'s born nation, is a store accessor of [metadata]
# @!attribute [rw] scadenza_rapporto
#   @return [String] {User}'s end of work, is a store accessor of [metadata]
# @!attribute [rw] tipo_contratto
#   @return [String] {User}'s work type, is a store accessor of [metadata]
# @!attribute [rw] denominazione_contratto
#   @return [String] {User}'s extended work type, is a store accessor of [metadata]
# @!attribute [rw] location
#   @return [String] {User}'s work city, is a store accessor of [metadata]
# @!attribute [rw] floor
#   @return [String] {User}'s work floor, is a store accessor of [metadata]
# @!attribute [rw] room
#   @return [String] {User}'s work room, is a store accessor of [metadata]
# @!attribute [rw] telephone
#   @return [String] {User}'s phone number, is a store accessor of [metadata]
# @!attribute [rw] emergenze
#   @return [String] {User}'s phone number for emergency, is a store accessor of [metadata]
# @!attribute [rw] structure
#   @return [String] {User}'s work area, is a store accessor of [metadata]
# @!attribute [rw] structure_label
#   @return [String] {User}'s work area extended, is a store accessor of [metadata]
# @!attribute [rw] responsabile
#   @return [String] {User}'s boss, is a store accessor of [metadata]
# @!attribute [rw] data_aggiornamento
#   @return [String] data of last metadata update, is a store accessor of [metadata]
# @!attribute [rw] prefix
#   @return [String] is a store accessor of [metadata]
# @!attribute [rw] author
#   @return [Object] instance of {User} as {secretary} thats update current instance. Is an attr_accessor
# @!attribute [rw] external
# @!attribute [rw] data
#   @return [Hash] data for update metadata
#
# @!method content()
#   @return [String] is a rich text with user info
# @!method assegnazione()
#   @return is an acchacched PDF
# @!method audits()
#   @return [Array] list of related {Audit}
# @!method categories()
#   @return [Array] list of related {Category}
# @!method meetings()
#   @return [Array] list of related {Meeting}
# @!method events()
#   @return [Array] list of related {Event}
# @!method histories()
#   @return [Array] list of related {History}
# @!method self.locked()
#   @return [Array] list of {User} with {locked_at} present and {deleted} false
# @!method self.unassigned()
#   @return [Array] list of {User} with no {audits}
# @!method self.blocked()
#   @return [Array] list of {User} with locked_at empty and {deleted} true
# @!method self.doctors()
#   @return [Array] list of {User} with {doctor} true
# @!method self.male()
#   @return [Array] list of {User} with {metadata} ->> sex = M
# @!method self.female()
#   @return [Array] list of {User} with {metadata} ->> sex = F
# @!method self.syncable()
#   @return [Array] list of {User} with {username} present
class User < ApplicationRecord
  has_rich_text :content
  has_one_attached :assegnazione

  has_many :audits, dependent: :destroy
  has_many :categories, through: :audits
  has_many :meetings, through: :audits
  has_many :events, through: :meetings
  has_many :histories, through: :audits, source: :histories
  has_many :risks, through: :categories, source: :risks

  store_accessor :metadata, :email, :sex, :lastname, :name, :matr, :status, :postazione_inizio, :postazione_fine, :postazione_locazione, :postazione_created_at, :postazione_updated_at, :data_nasc, :citta_nasc, :naz_nasc, :scadenza_rapporto, :tipo_contratto, :denominazione_contratto, :location, :floor, :room, :telephone, :emergenze, :user_emergenze, :structure, :structure_label, :responsabile, :data_aggiornamento, :prefix
  attr_accessor :author, :external, :data

  enum city: Settings.users.cities.to_h
  enum postazione: Settings.users.positions.to_h

  devise Settings.auth.authenticator.present? ? Settings.auth.authenticator.to_sym : :database_authenticatable, :trackable, :timeoutable, :lockable

  after_update :check_disabled
  before_destroy :abort_destroy

  accepts_nested_attributes_for :audits, reject_if: :reject_audit

  validates :username, uniqueness: true, allow_blank: true
  validates :label, presence: true
  validates :name, presence: { message: 'non può essere lasciato in bianco' }, unless: -> { system? }
  validates :lastname, presence: { message: 'non può essere lasciato in bianco' }, unless: -> { system? }
  validates :cf, presence: { message: 'non può essere lasciato in bianco' }, uniqueness: { message: 'già esistente' }, unless: -> { system? }
  validates :postazione, presence: true
  validates :assegnazione, content_type: { in: 'application/pdf', message: 'non è un file PDF' }
  validates :assegnazione, size: { less_than: 500.kilobytes, message: 'deve avere una dimensione massima di 500kb' }

  default_scope { where(locked_at: nil, deleted: false) }
  scope :locked, -> { unscoped.where.not(locked_at: nil).where.not(deleted: true) }
  scope :unassigned, -> { where.not(id: Audit.select(:user_id).distinct.pluck(:user_id)) }
  scope :blocked, -> { unscoped.where(deleted: true).where(locked_at: nil) }
  scope :doctors, -> { where(doctor: true).order(:label) }
  scope :male, -> { where("users.metadata->>'sex'=?", 'M') }
  scope :female, -> { where("users.metadata->>'sex'=?", 'F') }
  scope :syncable, -> { where.not(username: nil).order(:label) }
  scope :system, -> { where(system: true) }
  scope :unsystem, -> { where(system: false) }

  # update self with {locked_at} as Time.zone.now
  # @return [Boolean] true if is updated
  def disable!
    update(locked_at: Time.zone.now)
  end

  # update self with {locked_at} as nil
  # @return [Boolean] true if is updated
  def enable!
    update(locked_at: nil)
  end

  # override sex attribute
  # @return [String] return 'n.d.' if {sex} attribute is empty
  def sex
    metadata['sex'].blank? ? 'n.d.' : super
  end

  private

  # this method is called for check data befor make/update {Audit}
  # when return true the audit update is skypped
  # @param [Hash] attributed attributed is an hash with the params for make/update an {Audit}
  # @return [Boolean] true if attributed['title'] is empty
  def reject_audit(attributed)
    attributed['title'].blank?
  end

  # if {User} is locked destroy relative {Audit}
  def check_disabled
    return if locked_at.blank?

    audits.map do |a|
      a.author = author
      a.revision_date = Time.zone.now
      a.delete
    end
  end

  # is executed before destroy, add an error to :base and abort the action
  # @return [False]
  def abort_destroy
    errors.add :base, "Can't be destroyed"
    throw :abort
  end

end
