# frozen_string_literal: true

require 'yaml'
require 'singleton'

Item = Struct.new(:name, :code, :price, :quantity)

class Storage
  include Singleton

  attr_accessor :items

  def initialize
    @items = YAML.load_file('./data/items.yml').map do |item|
      Item.new(item['name'], item['code'], item['price'], item['quantity'])
    end
  end

  def find_item(code)
    items.find { |i| i.code.to_s == code.to_s && i.quantity.positive? }
  end
end
