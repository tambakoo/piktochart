# frozen_string_literal: true

RSpec.describe Basket do
  let(:product_catalogue) { ProductCatalogue.new }
  let(:delivery_rules) { DeliveryRules.new }
  let(:offers) { [] }

  subject(:basket) do
    described_class.new(
      product_catalogue: product_catalogue,
      delivery_rules: delivery_rules,
      offers: offers
    )
  end

  describe '#add' do
    it 'adds a known product code to the basket' do
      basket.add('R01')

      expect(basket.product_codes).to eq(['R01'])
    end

    it 'raises an error for an unknown product code' do
      expect { basket.add('ABC') }.to raise_error(ArgumentError, 'Unknown product code: ABC')
    end
  end

  describe '#product_codes' do
    it 'returns a duplicate of the basket product codes' do
      basket.add('R01')

      product_codes = basket.product_codes
      product_codes << 'ABC'

      expect(basket.product_codes).to eq(['R01'])
    end
  end

  describe '#total' do
    it 'returns $0.00 for an empty basket' do
      expect(basket.total).to eq('$0.00')
    end

    it 'calculates B01, G01 as $37.85' do
      basket.add('B01')
      basket.add('G01')

      expect(basket.total).to eq('$37.85')
    end

    it 'calculates R01, G01 as $60.85' do
      basket.add('R01')
      basket.add('G01')

      expect(basket.total).to eq('$60.85')
    end

    context 'with the red widget (R01) offer' do
      let(:offers) do
        [ProductQuantityDiscountOffer.new(product_code: 'R01', every_nth_item: 2, discount_percentage: 50)]
      end

      it 'calculates R01, R01 as $54.37' do
        basket.add('R01').add('R01')

        expect(basket.total).to eq('$54.37')
      end

      it 'calculates B01, B01, R01, R01, R01 as $98.27' do
        basket.add('B01').add('B01').add('R01').add('R01').add('R01')

        expect(basket.total).to eq('$98.27')
      end
    end
  end
end
