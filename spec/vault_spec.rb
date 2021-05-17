# frozen_string_literal: true

require 'yaml'
require_relative '../lib/vault'

RSpec.describe Vault do
  let(:coins_list) { YAML.load_file('./coins.yml') }
  let(:coin) { ->(attr_name) { coins_list.last[attr_name] } }
  let(:correct_attributes) do
    {
      name: coin['name'],
      value: coin['value'],
      quantity: coin['quantity']
    }
  end

  describe '#find_coin' do
    subject { described_class.instance.find_coin(value) }

    shared_examples_for :find_coin do
      it { is_expected.to have_attributes(correct_attributes) }

      context 'with invalid value' do
        let(:value) { '123' }

        it { is_expected.to be_nil }
      end
    end

    context 'by name' do
      it_behaves_like :find_coin do
        let(:value) { coin['name'] }
      end
    end

    context 'by value' do
      it_behaves_like :find_coin do
        let(:value) { coin['value'] }
      end
    end
  end

  describe '#find_coin_for_change' do
    subject { described_class.instance.find_coin_for_change(value) }

    let(:value) { coin['value'] }

    it { is_expected.to have_attributes(correct_attributes) }

    context 'when last coin quantity 0' do
      before do
        described_class.instance.coins.last.quantity = 0
      end

      it { is_expected.to have_attributes(name: coins_list.dig(-2, 'name'), value: coins_list.dig(-2, 'value')) }
    end
  end

  describe 'top_up' do
    let(:coin_struct) { Coin = Struct.new(:name, :value, :quantity) }
    let(:user_coins) { [coin_struct.new(coin['name'], coin['value'], 1)] }

    before do
      described_class.instance.top_up(user_coins)
    end

    it 'increases last coin quantity' do
      expect(described_class.instance.coins.last.count).to eq(coin['quantity'] + 1)
    end
  end

  describe '#coins' do
    it 'returns array of coins' do
      expect(described_class.instance.coins).to be_instance_of(Array)
    end

    it 'contains the same number of elements as in yaml' do
      expect(described_class.instance.coins.count).to eq(coins_list.count)
    end
  end
end
