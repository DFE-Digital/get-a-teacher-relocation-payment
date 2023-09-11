class DeleteStaleFormsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Form
      .where("created_at < ?", 1.day.ago)
      .delete_all
  end
end
