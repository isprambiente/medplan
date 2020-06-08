# frozen_string_literal: true

require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  test 'valid from factory' do
    meeting = build(:meeting)
    assert meeting.save
  end

  # struttura DB
  should have_db_column(:id)
  should have_db_column(:audit_id)
  should have_db_column(:event_id)
  should have_db_column(:status)
  should have_db_column(:start_at)
  should have_db_column(:stop_at)
  should have_db_column(:body)
  should have_db_column(:sended_at)

  should have_db_index(:audit_id)
  should have_db_index(:event_id)
  should have_db_index(:start_at)
  should have_db_index(:status)

  should define_enum_for(:status)

  # relations
  should belong_to(:audit)
  should belong_to(:event)
  should have_one(:user)
  should have_one(:category)

  # validations
  should validate_presence_of(:audit)
  should validate_presence_of(:event)
  should validate_presence_of(:start_at)

  test 'validate_uniqueness_of_event' do
    meeting1 = create :meeting
    meeting2 = build  :meeting, audit: meeting1.audit, event: meeting1.event
    assert_not meeting2.valid?
    meeting2.audit = create :audit
    assert meeting2.valid?
  end

  # Callback

  test 'add_stop_at_after_validate' do
    meeting = create :meeting, stop_at: nil
    assert meeting.valid?
    meeting.save
    assert meeting.stop_at.present?
  end

  test 'after_destroy_remove_empty_event' do
    event = create :event
    a = create :meeting, event: event
    b = create :meeting, event: event
    a.destroy
    assert_equal 1, Event.all.count
    b.destroy
    assert_equal 0, Event.all.count
  end
end
