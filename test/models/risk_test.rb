# frozen_string_literal: true

require 'test_helper'

class RiskTest < ActiveSupport::TestCase
  test 'valid from factory' do
    risk = build(:risk)
    assert risk.save
  end

  # struttura DB
  should have_db_column(:id)
  should have_db_column(:code)
  should have_db_column(:title)
  should have_db_column(:printed)

  should have_db_index(:title)

  # relations
  should have_many(:category_risks)
  should have_many(:categories).through(:category_risks)

  # validations
  should validate_presence_of(:title)
  should validate_uniqueness_of(:title)

  # scope
  test 'default_scope' do
    b = create :risk, title: 'b'
    a = create :risk, title: 'a'
    assert_equal a, Risk.all.first
    assert_equal b, Risk.all.last
  end

  test 'printed' do
    create :risk, printed: false, code: '1'
    b = create :risk, printed: true, code: '3'
    c = create :risk, printed: true, code: '2'
    assert_equal 2, Risk.printed.count
    assert_equal c, Risk.printed.first
    assert_equal b, Risk.printed.last
  end
end
