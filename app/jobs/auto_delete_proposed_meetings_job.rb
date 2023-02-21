class AutoDeleteProposedMeetingsJob < ApplicationJob
  queue_as :low_priority

  def perform(*args)
    Meeting.deletables.delete_all
  end
end
