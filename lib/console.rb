# frozen_string_literal: true

require 'colorize'

class Console
  HEADERS      = %w[Code Name Price Quantity].freeze
  DIVIDER_SIZE = 50
  COLUMN_SIZE  = DIVIDER_SIZE / HEADERS.size

  class << self
    def print_menu(items)
      puts '-' * DIVIDER_SIZE
      puts formatted_string(*HEADERS)
      puts '-' * DIVIDER_SIZE
      items.each do |item|
        next if item.quantity.zero?

        puts formatted_string(item.code.to_s, item.name, "#{item.price}$", item.quantity.to_s)
      end
      puts '-' * DIVIDER_SIZE
      puts 'To order please enter the product code:'.green
    end

    def item_error
      puts 'I don\'t have items with this code.'.red
      puts 'Please use correct one.'.red
    end

    def insert_coin_message
      puts 'Please insert coin (25c 50c 1$ 2$ 3$ 5$):'.blue
    end

    def insert_coin_error
      puts 'We don\'t support this coin!'.red
    end

    def more_coins(balance, needed_balance)
      puts 'Please insert more coins.'.blue
      puts "Your balance: #{balance}$".light_blue
      puts "Needed: #{needed_balance}$".light_blue
    end

    def take_item(item_name)
      puts "Take your #{item_name}".green
    end

    def change(change)
      puts 'Your change:'.blue
      change.each { |coin, quantity| puts "#{coin}$ - #{quantity}".light_blue }
    end

    def change_error
      puts 'Sorry, I don\'t have enough money to return you change.'.red
      puts 'Please message our support'.red
    end

    private

    def formatted_string(code, name, price, quantity)
      code.ljust(COLUMN_SIZE) +
        name.ljust(COLUMN_SIZE) +
        price.ljust(COLUMN_SIZE) +
        quantity.ljust(COLUMN_SIZE)
    end
  end
end
