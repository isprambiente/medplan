# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid from factory' do
    user = build(:user)
    assert user.save
  end

  # struttura DB
  should have_db_column(:id)
  should have_db_column(:sign_in_count)
  should have_db_column(:current_sign_in_at)
  should have_db_column(:last_sign_in_at)
  should have_db_column(:current_sign_in_ip)
  should have_db_column(:last_sign_in_ip)
  should have_db_column(:locked_at)
  should have_db_column(:username)
  should have_db_column(:label)
  should have_db_column(:city)
  should have_db_column(:body)
  should have_db_column(:secretary)
  should have_db_column(:doctor)
  should have_db_column(:admin)
  should have_db_column(:deleted)
  should have_db_column(:cf)
  should have_db_column(:tel)
  should have_db_column(:postazione)
  should have_db_column(:metadata)

  should have_db_index(:cf).unique(true)

  should define_enum_for(:city)
  should define_enum_for(:postazione)

  # relations
  should have_many(:audits)
  should have_many(:categories).through(:audits)
  should have_many(:meetings).through(:audits)
  should have_many(:events).through(:meetings)
  should have_many(:histories).through(:audits)

  # validations
  should validate_presence_of(:label)
  should validate_presence_of(:cf)
  should validate_presence_of(:postazione)
  test 'validate_presence_of_name' do
    user = create :user
    user.name = nil
    assert_not user.valid?
  end
  test 'validate_presence_of_lastname' do
    user = create :user
    user.lastname = nil
    assert_not user.valid?
  end
  test 'validate_uniqueness_of_cf' do
    a = create :user
    b = create :user
    b.cf = a.cf
    assert_not b.valid?
  end
  test 'validate_uniqueness_of_username' do
    a = create :user
    b = create :user
    b.username = a.username
    assert_not b.valid?
    b.username = nil
    assert b.valid?
  end

  # scope
  test 'users_scope_locked' do
    a = create :user, deleted: false, locked_at: Time.zone.now
    create :user, deleted: false, locked_at: nil
    create :user, deleted: true, locked_at: Time.zone.now
    create :user, deleted: true, locked_at: nil
    assert_equal 1, User.locked.count
    assert_equal a, User.locked.first
  end

  test 'users_scope_unassigned' do
    a = create :user
    create(:audit).user
    assert_equal 1, User.unassigned.count
    assert_equal a, User.unassigned.first
  end

  test 'users_scope_blocked' do
    a = create :user, deleted: true, locked_at: nil
    create :user, deleted: true, locked_at: Time.zone.now
    create :user, deleted: false, locked_at: nil
    create :user, deleted: false, locked_at: Time.zone.now
    assert_equal 1, User.blocked.count
    assert_equal a, User.blocked.first
  end

  test 'users_scope_doctors' do
    a = create :user, doctor: true
    create :user, doctor: false
    assert_equal 1, User.doctors.count
    assert_equal a, User.doctors.first
  end

  test 'users_scope_male' do
    a = create :user
    b = create :user
    b.update sex: 'F'

    assert_equal 1, User.male.count
    assert_equal a, User.male.first
  end

  test 'users_scope_female' do
    create :user
    b = create :user
    b.update sex: 'F'
    assert_equal 1, User.female.count
    assert_equal b, User.female.first
  end

  test 'user_scope_syncable' do
    create :user, username: nil
    b = create :user
    assert_equal 1, User.syncable.count
    assert_equal b, User.syncable.first
  end

  # methods
  test 'delete' do
    u = create :user
    assert_not u.locked_at.present?
    u.delete
    assert_not u.destroyed?
    assert u.locked_at.present?
  end

  test 'destroy' do
    u = create :user
    assert_not u.locked_at.present?
    u.destroy
    assert_not u.destroyed?
    assert u.locked_at.present?
  end

  test 'update_user_data' do
    u = create :user
    u.update lastname: 'none'
    u.update_user_data
    assert_equal 'test', u.lastname
  end

  test 'sex' do
    u = create :user
    assert_equal 'M', u.sex
    u.update sex: nil
    assert_equal 'n.d.', u.sex
  end

  test 'prerequisite' do
    u = create :user, metadata: nil
    assert u.metadata.present?
  end

  test 'get_data' do
    u = create :user
    u.update lastname: 'none'
    assert u.send(:get_data)
    assert_equal 'test', u.lastname
  end

  test 'reject_audit' do
    u = User.new
    assert u.send(:reject_audit, { 'title' => nil })
    assert u.send(:reject_audit, { 'title' => '' })
    assert_not u.send(:reject_audit, { 'title' => 'asd' })
  end
end
