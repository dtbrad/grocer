class EmailWorker
  include Sidekiq::Worker

  def perform(list_id)
    @shopping_list = ShoppingList.find(list_id)
    ListMailer.list_mailer(@shopping_list).deliver
  end
end
