# README

I'll aim to keep this README updated as I progress.

Grocer accesses a user's gmail inbox using oAuth2, searches for and parses email receipts from New Seasons Market, then transforms that data into a database of shopping receipts (baskets), line items, and products that a user can navigate through and sort through. Basic analytics are presented in charts at the top of the index pages. More features on the way.

Grocer is currently deployed at [https://new-seasons.herokuapp.com](https://new-seasons.herokuapp.com)

To install and use locally:

1. Fork and clone this repo
2. Authorize this app with google and set up OAuth 2.0 credentials. Among other things, google will ask you for a redirect_uri. For local use, it will be: http://localhost:3000/auth/google_oauth2/callback
3. Create a .env file in the root directory and list it in your .gitignore file. Inside of it enter your google_client_id and google_secret in the following form:

  ```
  GOOGLE_CLIENT_ID=12345
  GOOGLE_SECRET=12345
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

7. To start up the server:
  ```
  rails s
  ```

8. Then visit http://localhost:3000
