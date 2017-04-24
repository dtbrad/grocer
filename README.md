# README

Grocer is currently deployed at [https://www.my-grocer.com](https://www.my-grocer.com)

I'll aim to keep this README updated as I progress. Grocer accesses a user's gmail inbox using Oauth2 and the google api library, searches for and parses email receipts from New Seasons Market using Nokogiri, then transforms that data into a SQL database of shopping receipts (baskets), line items, and products that a user can navigate, sort, and search. Detailed analytics are presented in charts at the top of the index and show pages. Grocer also includes a "smart" shopping list maker built with AngularJS(1) that leverages the product information in the database to allow users to quickly make lists with accurate pricing information baked in. Lists are automatically emailed to the user when saved.

Receipts from New Seasons Market sometimes contain abbreviated or otherwise unclear product names, so on each product show page there is an input for a product "nickname". Nicknames submitted by regular users through that input are routed to a review queue accessible only by admin-level users, where they can be approved or rejected. Admin-level users can also directly edit nicknames on the product show pages without additional review. Once a nickname is submitted/approved, the product will appear only by its nickname, for both past shopping receipts as well as any that are scraped in the future.

Additionally, New Seasons Market often fails to include unit pricing and weight amounts on items from their meat, fish and deli counters, giving the user only a total price for the. I added a feature, currently usable only from the console, that enables an admin to artificially add a unit price to a product and add that unit price to all past and future line_items for that product. The weight amount is derived by dividing the total price by the inserted unit price. Line items that have been modified this way are highlighted in the basket show views.

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

6. In your terminal, enter the following. And note that currently this app requires that you seed the database. Otherwise the "Sample User account" buttons on the home, login and register pages will not function.
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


MIT License

Copyright (c) 2017 Daniel Brad

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
