# frozen_string_literal: true

# This job is used to delete proposed meetings that are no longer valid.
# It is scheduled to run every day at midnight, but it can be customized if needed.
class AutoDeleteProposedMeetingsJob < ApplicationJob
  queue_as :low_priority

  # This method is called when the job is executed.
  # It deletes all proposed meetings that are no longer valid.
  def perform(*args)
    Meeting.deletables.delete_all
  end
end
