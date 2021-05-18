# frozen_string_literal: true

require_relative 'console'
require_relative 'storage'
require_relative 'vault'

class VendingMachine
  attr_accessor :vault, :storage, :coins, :item

  def initialize
    @vault = Vault.instance
    @storage = Storage.instance
    @coins = []
    @item = nil
  end

  def execute
    Console.print_menu(storage.items)

    find_item
    insert_coin
    return_item
    return_change
    reset
    execute
  end

  private

  def find_item
    unless @item = storage.find_item(gets.chomp)
      Console.item_error
      execute
    end
  end

  def insert_coin
    Console.insert_coin_message
    inserted_coin = gets.chomp

    unless vault.coins.map(&:name).include?(inserted_coin) || vault.coins.map(&:value).include?(inserted_coin.to_f)
      Console.insert_coin_error
      return insert_coin
    end

    coin = vault.find_coin(inserted_coin)

    coins << Coin.new(coin.name, coin.value, 1)

    while total < item.price
      Console.more_coins(total, item.price - total)
      return insert_coin
    end
  end

  def return_item
    storage.find_item(item.code).quantity -= 1
    Console.take_item(item.name)
    vault.top_up(coins)
  end

  def return_change
    redundant = total - item.price
    change = []

    while redundant.positive?
      coin = vault.find_coin_for_change(redundant)
      if coin
        change << coin.value
        coin.quantity -= 1
        redundant -= coin.value
      else
        Console.change_error
        return execute
      end
    end
    Console.change(change.tally) if change.any?
  end

  def reset
    @coins = []
    @item = nil
  end

  def total
    coins.sum(&:value)
  end
end

VendingMachine.new.execute
