# Vending Machine

## Task:

Design a vending machine in code. The vending machine, once a product is selected and the appropriate amount of money (coins) is inserted, should return that product. It should also return change (coins) if too much money is provided or ask for more money (coins) if there is not enough (change should be printed as coin * count and as minimum coins as possible).
Keep in mind that you need to manage the scenario where the item is out of stock or the machine does not have enough change to return to the customer.
Available coins: 25c, 50c, 1$, 2$, 3$, 5$

## How to setup a project:

Run `bundle install` in your terminal.

## How to run a project:

To start this application run `ruby lib/vending_machine.rb` in your terminal.

All coins and their counts are described in `data/coins.yml`.
You can add your own supported coins.

All items and their counts are described in `data/item.yml`.
You can add your own items there.

## How to run tests:

To run specs run `rspec` in your terminal.
