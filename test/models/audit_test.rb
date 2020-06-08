# frozen_string_literal: true

require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  test 'valid from factory' do
    a = create(:audit)
    assert a.persisted?
  end

  # DB structure
  should have_db_column(:id)
  should have_db_column(:user_id)
  should have_db_column(:category_id)
  should have_db_column(:status)
  should have_db_column(:expire)

  should have_db_index(:category_id)
  should have_db_index(:user_id)
  should have_db_index(:status)
  should have_db_index(:expire)

  # relations
  should belong_to(:category)
  should belong_to(:user)
  should have_many(:histories)
  should have_many(:meetings)
  should have_many(:events).through(:meetings)

  # validations
  should validate_presence_of(:user_id)

  test 'uniqueness of expire scope user_id, status' do
    time = Time.zone.now + 1.day
    user = create :user
    create :audit, user: user, status: :created, expire: time
    a2 = build(:audit, user: user, status: :created, expire: time)
    assert_not a2.valid?
  end

  # scopes
  test 'default scope' do
    create :audit, status: :deleted
    a2 = create :audit, status: :created
    assert_equal 1, Audit.count
    assert_equal a2, Audit.first
  end

  test 'scope active' do
    create :audit, status: :deleted
    a2 = create :audit, status: :created
    create :audit, status: :change_date_next_visit
    assert_equal 1, Audit.active.count
    assert_equal a2, Audit.active.first
  end

  test 'scope ordered_by_category_title' do
    c1 = create :category, title: 'b'
    c2 = create :category, title: 'a'
    create :audit, category: c1
    a2 = create :audit, category: c2
    assert_equal a2, Audit.ordered_by_category_title.first
  end

  test 'scope deleted' do
    a1 = create :audit, status: :deleted
    create :audit, status: :created
    assert_equal 1, Audit.deleted.count
    assert_equal a1, Audit.deleted.first
  end

  # methods
  test 'state' do
    a = create :audit
    assert_equal 'History', a.state.class.name
    assert_equal a.state, a.histories.last
  end

  test 'expired?' do
    a = create :audit
    a.expire = Time.zone.now + 1.day
    assert_not a.expired?
    a.expire = Time.zone.now - 1.day
    assert a.expired?
  end
end
