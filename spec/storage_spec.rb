# frozen_string_literal: true

require 'yaml'
require_relative '../lib/storage'

RSpec.describe Storage do
  subject { described_class.instance.find_item(code) }

  let(:items_list) { YAML.load_file('./items.yml') }
  let(:item) { ->(attr_name) { items_list.first[attr_name] } }
  let(:code) { item['code'] }
  let(:correct_attributes) do
    {
      name: item['name'],
      code: item['code'],
      price: item['price'],
      quantity: item['quantity']
    }
  end

  describe '#find_item' do
    it { is_expected.to have_attributes(correct_attributes) }

    context 'when item quantity 0' do
      before do
        described_class.instance.items.first.quantity = 0
      end

      it { is_expected.to be_nil }
    end

    context 'with invalid code' do
      let(:code) { '123' }

      it { is_expected.to be_nil }
    end
  end

  describe '#items' do
    it 'returns array of items' do
      expect(described_class.instance.items).to be_instance_of(Array)
    end

    it 'contains the same number of elements as in yaml' do
      expect(described_class.instance.items.count).to eq(items_list.count)
    end
  end
end
