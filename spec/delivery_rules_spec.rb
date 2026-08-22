# frozen_string_literal: true

RSpec.describe DeliveryRules do
  subject(:delivery_rules) { described_class.new }

  describe '#charge_for' do
    it 'charges $4.95 for orders under $50' do
      expect(delivery_rules.charge_for(4999)).to eq(495)
      expect(delivery_rules.charge_for(5000)).not_to eq(495)
    end

    it 'charges $2.95 for orders from $50 up to under $90' do
      expect(delivery_rules.charge_for(4999)).not_to eq(295)
      expect(delivery_rules.charge_for(5000)).to eq(295)
      expect(delivery_rules.charge_for(8999)).to eq(295)
    end

    it 'charges $0.00 for orders of $90 or more' do
      expect(delivery_rules.charge_for(4999)).not_to eq(0)
      expect(delivery_rules.charge_for(8999)).not_to eq(0)
      expect(delivery_rules.charge_for(9000)).to eq(0)
    end

    it 'rejects negative subtotals' do
      expect do
        delivery_rules.charge_for(-123)
      end.to raise_error(ArgumentError,
                         'Subtotal must be a non-negative integer amount of cents')
    end

    it 'rejects non-integer subtotals' do
      expect do
        delivery_rules.charge_for('4999')
      end.to raise_error(ArgumentError,
                         'Subtotal must be a non-negative integer amount of cents')
    end
  end
end
