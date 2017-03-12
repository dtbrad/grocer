class BasketWorker
  include Sidekiq::Worker

  def perform(id, date, token)
    user = User.find(id)
    Scraper.process_emails(user, date, token)
    ActionCable.server.broadcast "notifications:#{user.id}", {html:
      "<div class='alert alert-success'>ActionCable says that your receipts are now imported.</div>"}
  end
end
