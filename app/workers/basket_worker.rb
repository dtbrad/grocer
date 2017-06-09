class BasketWorker
  include Sidekiq::Worker

  def perform(id, date, token, orig_email="")
    user = User.find(id)
    orig_count = user.baskets.count

    ActionCable.server.broadcast "notifications:#{user.id}", {html:
      "<div class='alert alert-warning alert-block text-center'>
         <i class='fa fa-circle-o-notch fa-spin'></i>
         Searching your gmail for receipts now (it might take a minute if there are many).
      </div>"
    }

    Scraper.process_emails(user, date, token, orig_email)

    if user.baskets.count > orig_count
      ActionCable.server.broadcast "notifications:#{user.id}", {html:

        "<div class='alert alert-success alert-block text-center'>
          Search complete! Note that on June 7, 2016 New Seasons Market changed the format of their email receipts. I'm working on refactoring my application to process the new receipts, but until then Grocer will only import receipts from before that date.
        </div>
        <a href='/baskets' class='btn btn-default btn-block'>
          #{user.baskets.count - orig_count} new receipts imported. Click here to see your updated history.
        </a>",
        text: "#{user.baskets.count - orig_count} new receipts imported."
      }
    else
      ActionCable.server.broadcast "notifications:#{user.id}", {html:
        "<div class='alert alert-danger'>No (new) receipts found. Note that on June 7, 2016 New Seasons Market changed the format of their email receipts. I'm working on refactoring my application to process the new receipts, but until then Grocer will only import receipts from before that date</div>",
        text: "Search complete. No (new) receipts found"
      }
    end
  end
end
