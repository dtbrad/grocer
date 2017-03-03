class BasketWorker
  include Sidekiq::Worker

  def perform(id, date, token)
    # binding.pry
    user = User.find(id)
    Scraper.process_emails(user, date, token)
    # Do something
  end
end
