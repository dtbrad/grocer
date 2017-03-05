# README

Grocer is currently deployed at [https://new-seasons.herokuapp.com](https://new-seasons.herokuapp.com)

I'll aim to keep this README updated as I progress. Grocer accesses a user's gmail inbox using Oauth2, searches for and parses email receipts from New Seasons Market, then transforms that data into a database of shopping receipts (baskets), line items, and products that a user can navigate, sort, and search. Detailed analytics are presented in charts at the top of the index and show pages. Grocer also includes a "smart" shopping list maker that leverages the product information in the database to allow users to quickly make lists with accurate pricing information baked in. Lists are automatically emailed to the user when saved.

Receipts from New Seasons Market sometimes contain abbreviated or otherwise unclear product names, so on each product show page there is an input for a product "nickname". Nicknames submitted by regular users through that input are routed to a review queue accessible only by admin-level users, where they can be approved or rejected. Admin-level users can also directly edit nicknames on the product show pages without additional review. Once a nickname is submitted/approved, the product will appear only by its nickname, for both past shopping receipts as well as any that are scraped in the future.

To install and use locally:

1. Fork and clone this repo
2. Authorize this app with google and set up Oauth 2.0 credentials. Among other things, google will ask you for a redirect_uri. For the app's current setup you will need to supply two: http://localhost:3000/users/auth/google_oauth2/callback and http://localhost:3000/auth/google_oauth2/callback
3. Create a .env file in the root directory and list it in your .gitignore file. Inside of it create env variables for the credentials supplied by google, as well as for an email account from which to send shopping lists and email confirmation links:

  ```
  GOOGLE_CLIENT_ID=12345
  GOOGLE_SECRET=12345
  gmail_username=yourgmailaddress@gmail.com
  gmail_password=password1234
  ```

4. In the same file create an env variable for the redirect uri  your google-api_controller needs for proper routing of its Oauth2 workflow for email scraping:

  ```
  redirect_uri=http://localhost:3000/auth/google_oauth2/callback

  ```

6. In your terminal, enter the following:
  ```
  bundle install
  rake db:create
  rake db:migrate
  rake db:seed
  
  ```

10. Then start up your redise, sidekiq, and rails servers:
  ```
  redis-server
  bundle exec sidekiq
  rails s
  ```

11. And in your browser, visit http://localhost:3000
