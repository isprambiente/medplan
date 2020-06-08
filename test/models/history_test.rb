# frozen_string_literal: true

require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  test 'valid from factory' do
    history = build(:history)
    assert history.valid?
  end

  # struttura DB
  should have_db_column(:id)
  should have_db_column(:audit_id)
  should have_db_column(:status)
  should have_db_column(:doctor)
  should have_db_column(:revision_date)
  should have_db_column(:body)
  should have_db_column(:lab)
  should have_db_column(:city)
  should have_db_column(:log)

  should have_db_index(:audit_id)
  should have_db_index(:city)
  should have_db_index(:log)
  should have_db_index(:revision_date)
  should have_db_index(:status)

  # relations
  should belong_to(:audit)
  should have_one(:user).through(:audit)
  should have_one(:category).through(:audit)
  should have_one(:category_risks).through(:category)
  should have_one(:risk).through(:category_risks)

  # validations
  should validate_presence_of(:doctor)
  should validate_presence_of(:author)
  should validate_presence_of(:status)
  should validate_inclusion_of(:status).in_array(Settings.history.status)
  should validate_presence_of(:revision_date)

  # scope
  test 'default_scope' do
    audit = create :audit
    History.delete_all
    a = create :history, log: false, audit: audit
    create :history, log: true, audit: audit
    assert_equal 1, History.all.count
    assert_equal a, History.all.first
  end

  test 'scope active' do
    audit = create :audit
    History.delete_all
    a = create :history, log: false, audit: audit
    create :history, log: true, audit: audit
    create :history, status: 'change_date_next_visit', log: false, audit: audit
    assert_equal 1, History.active.count
    assert_equal a, History.active.first
  end

  test 'scope between' do
    audit = create :audit
    History.delete_all
    create :history, revision_date: Time.zone.today - 2.years, audit: audit, log: false
    create :history, revision_date: Time.zone.today + 2.years, audit: audit, log: false
    c = create :history, revision_date: Time.zone.today, audit: audit, log: false
    create :history, revision_date: Time.zone.today, log: true, audit: audit
    assert_equal 1, History.between.count
    assert_equal c, History.between.first
  end

  # method
  test 'delete' do
    a = create :history
    assert_not a.delete
    assert a.persisted?
  end

  test 'destroy' do
    a = create :history
    assert_not a.destroy
    assert a.persisted?
  end

  # private method
  test 'require_doctor?' do
    assert build(:history, log: false, status: 'suitable').send(:require_doctor?)
    assert_not build(:history, log: true).send(:require_doctor?)
    assert_not build(:history, status: 'created').send(:require_doctor?)
    assert_not build(:history, status: 'deleted').send(:require_doctor?)
  end
end
