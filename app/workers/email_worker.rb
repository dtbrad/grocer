class EmailWorker
  include Sidekiq::Worker

  def perform(id, date)
    user = User.find(id)
    Scraper.process_emails(user, date)
    # Do something
  end
end
