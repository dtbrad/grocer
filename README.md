# README

Still a work in progress. I'll aim to keep this README updated as I progress.

The app currently is set up to obtain permission to access a user's gmail inbox, then search for email receipts from New Seasons Market and transform the data from those into a database of shopping receipts and individual products that the user can search through. Later on I'll be adding various analytics to help users learn more about their grocery shopping habits, as well as improving the user interface.

To install and use locally:

1. Fork and clone this repo
2. Authorize this app with google and set up OAuth 2.0 credentials. Among other things, google will ask you for a redirect_uri. For local use, it will be: http://localhost:3000/auth/google_oauth2/callback
3. Create a .env file in the root directory. Inside of it enter your google_client_id and google_secret in the following form:

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
