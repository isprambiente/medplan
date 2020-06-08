# frozen_string_literal: true

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test 'valid from factory' do
    category = build(:category)
    assert category.valid?
  end

  # struttura DB
  should have_db_column(:id)
  should have_db_column(:code)
  should have_db_column(:title)
  should have_db_column(:months)
  should have_db_column(:protocol)
  should have_db_column(:active)

  should have_db_index(:active)
  should have_db_index(:title)

  # relations
  should have_many(:audits)
  should have_many(:category_risks)
  should have_many(:users).through(:audits)
  should have_many(:risks).through(:category_risks)

  # validations
  should validate_presence_of(:title)
  should validate_presence_of(:months)

  # scope
  test 'default_scope' do
    create :category, title: 'a', active: false
    c2 = create :category, title: 'b', active: true
    c3 = create :category, title: 'c', active: true
    assert_equal 2,  Category.count
    assert_equal c2, Category.first
    assert_equal c3, Category.last
  end

  test 'disabled_scope' do
    c1 = create :category, title: 'a', active: false
    create :category, title: 'b', active: true
    create :category, title: 'c', active: true
    assert_equal 1,  Category.disabled.count
    assert_equal c1, Category.disabled.first
  end

  # method
  test 'delete set active false if users?' do
    c = create :category
    create :audit, category: c
    assert_equal 1, c.users.count
    c.delete
    assert c.persisted?
    assert_not c.active?
  end

  test 'delete destroy element if users is empy' do
    c = create :category
    assert_equal 0, c.users.count
    c.delete
    assert_not c.persisted?
  end
end
