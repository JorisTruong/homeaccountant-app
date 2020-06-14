# Home Accountant

Home Accountant is a FOSS (Free Open-Source Software) built to manage bank accounts.

# How it works

The application is built on multiple main pages:
1. The **Homepage** is where main information are displayed, like the total amount of expenses, of income, or the balance.
2. The **Accounts page** is where you can manage your different accounts.
3. The **Transactions page** is where we can find all the transactions. They are organized by months.
4. The **Categories page** is where we can find all the defined categories and subcategories for a transaction.
5. The **Graphs page** is where different graphs are displayed. Pie charts, bar charts, line charts, for more graphical information on your transactions.

Home Accountant is also organized in accounts. That is, you can build multiple accounts and save transactions independently from other accounts. The information on the transactions page, graphs page or charts page are based on the selected account. It is also possible to selected a particular date range in which the information showed will be based on the date range.

Home Accountant is build using [Flutter](https://flutter.dev/) and [Redux](https://pub.dev/packages/redux) as a state management tool. You can learn more about Redux [here](https://redux.js.org/).

# Roadmap

We are listing here all the improvements that are currently planned to be made for the application.

### High priority:
* Confirmation when deleting a transaction, category or account
* Complete 'About Us' page
* Define the categories and their icon
* Create a logo
* Local back-end development

### Medium priority:
* Add a toast on creation of an account, transaction or subcategory
* Ability to select all accounts
* Design the tooltip for line charts
* Support for different languages
* Support for multiple currencies
* Ability to select multiple accounts
* Import/Export option

### Low priority:
* Research bar in Categories
* Review navigation design
* Filter transactions by expense or not
* Clicking main cards in homepage navigates to transactions with eventual filters
* Add the ability to set a monthly budget amount for each category/subcategory
* Add the ability to move graph cards between them
* Add the ability for a transaction to be recurrent
* Self-hosting option