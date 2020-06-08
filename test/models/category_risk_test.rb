# frozen_string_literal: true

require 'test_helper'

class CategoryRiskTest < ActiveSupport::TestCase
  test 'valid from factory' do
    cr = build(:category_risk)
    assert cr.valid?
  end

  # struttura DB
  should have_db_column(:id)
  should have_db_column(:category_id)
  should have_db_column(:risk_id)

  should have_db_index(:category_id)
  should have_db_index(:risk_id)

  # relations
  should belong_to(:category)
  should belong_to(:risk)

  # validations
  test 'uniquenes of category_id scope risk_id' do
    risk = create :risk
    cr1 = build :category_risk, risk: risk
    assert cr1.save
    cr2 = build :category_risk, risk: risk
    assert cr2.valid?
    cr3 = build :category_risk, category: cr1.category, risk: risk
    assert_not cr3.valid?
  end
end
