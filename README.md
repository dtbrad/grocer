# README

Grocer is currently deployed at [https://www.my-grocer.com](https://www.my-grocer.com)

Grocer is a purchase tracking web app that parses a user's New Seasons Market e-receipts and transforms that data into a postgres database of baskets (i.e. receipts), line items, and products that a user can navigate, search and sort through. Detailed analytics are presented in interactive charts at the top of the index and show pages. Grocer also includes a "smart" shopping list maker built with AngularJS that leverages the product information in the database to allow users to quickly make lists with accurate pricing information baked in. Lists are automatically emailed to the user when saved.

A user may send their New Seasons receipts to Grocer in one of two ways. First they may forward their emails to Grocer's intake email address <intake@receipts.my-grocer.com>. Grocer uses the Mailgun API to transform those emails into `POST` requests that it processes with its parser. Short video guides for setting up an auto-forward filter are provided at [https://www.my-grocer.com/about](https://www.my-grocer.com/about). Second, users with gmail may choose to perform a bulk import of their receipts. Grocer will access the user's gmail inbox using Oauth2 and the google api library to search for and retrieve the e-receipts.

New Seasons Market e-receipts sometimes contain abbreviated or otherwise unclear product names, so on each product show page there is an input for a product "nickname". Nicknames submitted by regular users through that input are routed to a review queue accessible only by admin-level users, where they can be approved or rejected. Admin-level users can also directly edit nicknames on the product show pages without additional review. Once a nickname is submitted/approved, the product will appear only by its nickname, for both past shopping receipts as well as any that are scraped in the future.

Additionally, New Seasons Market often fails to include unit pricing and weight amounts on items from their meat, fish and deli counters, giving the user only a total price for the item (i.e. a $18 chicken thigh). Grocer allows an admin user to manually add a unit price to a given product - that new unit price will now affect all past and future line items for that product, generating a contrived weight derived by dividing the total price by the inserted unit price. Line items that have been generated this way are highlighted in the basket show views. Currently this feature is available from the rails console.

---
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
