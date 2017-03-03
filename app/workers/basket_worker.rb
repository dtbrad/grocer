class BasketWorker
  include Sidekiq::Worker

  def perform(id, date, token)
    user = User.find(id)
    Scraper.process_emails(user, date, token)
  end
end
