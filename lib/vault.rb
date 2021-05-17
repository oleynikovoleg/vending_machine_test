require 'yaml'
require 'singleton'

Coin = Struct.new(:name, :value, :quantity)

class Vault
  include Singleton

  attr_accessor :coins

  def initialize
    @coins = YAML.load_file('./coins.yml').map do |coin|
      Coin.new(coin['name'], coin['value'], coin['quantity'])
    end
  end

  def find_coin(value)
    @coins.find { |coin| coin.value.to_f == value.to_f || coin.name == value }
  end

  def find_coin_for_change(value)
    coin = @coins.select { |coin| coin.quantity.positive? }.min_by{ |x| (value - x.value).abs }
    coin && coin.value > value ? nil : coin
  end

  def top_up(user_coins)
    user_coins.each do |coin|
      find_coin(coin.value).quantity += 1
    end
  end
end
