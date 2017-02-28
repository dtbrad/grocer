# README

Grocer is currently deployed at [https://new-seasons.herokuapp.com](https://new-seasons.herokuapp.com)

I'll aim to keep this README updated as I progress. Grocer accesses a user's gmail inbox using oAuth2, searches for and parses email receipts from New Seasons Market, then transforms that data into a database of shopping receipts (baskets), line items, and products that a user can navigate, sort, and search. Detailed analytics are presented in charts at the top of the index and show pages. Grocer also includes a "smart" shopping list maker that leverages the product information in the database to allow users to quickly make lists with accurate pricing information baked in. Lists are automatically emailed to the user when saved.

Receipts from New Seasons Market sometimes contain abbreviated or otherwise unclear product names, so on each product show page there is an input for a product "nickname". Nicknames submitted by regular users through that input are routed to a review queue accessible only by admin-level users, where they can be approved or rejected. Admin-level users can also directly edit nicknames on the product show pages without additional review. Once a nickname is submitted/approved, the product will appear only by its nickname, for both past shopping receipts as well as any that are scraped in the future.

Currently this app requires full read/write access to a user's gmail account in order to scrape their emails. I know this is not ideal. Until this is fixed, users with security concerns can log in directly with any email and password, and will have full access to the smart shopping list maker. They can also explore the app's purchase history and product database features with the sample user account accessible through the sign-in page. Another option: just install it locally!

To install and use locally:

1. Fork and clone this repo
2. Authorize this app with google and set up OAuth 2.0 credentials. Among other things, google will ask you for a redirect_uri. For local use, it will be: http://localhost:3000/users/auth/google_oauth2/callback
3. Create a .env file in the root directory and list it in your .gitignore file. Inside of it enter your google_client_id and google_secret in the following form:

  ```
  GOOGLE_CLIENT_ID=12345
  GOOGLE_SECRET=12345
  ```
4. You also need to provide a gmail account that the app will use to send shopping lists (this will be the sender account).

  ```
  gmail_username=yourgmailaddress@gmail.com
  gmail_password=password1234
  ```

4. From your terminal, enter:
  ```
  bundle install
  ```

5. Then:
  ```
  rake db:create
  ```

6. Then:
  ```
  rake db:migrate
  ```

7. Then:
  ```
  rake db:seed
  ```

8. To start up the server:
  ```
  rails s
  ```

8. Then visit http://localhost:3000
