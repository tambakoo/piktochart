# frozen_string_literal: true

RSpec.describe ProductQuantityDiscountOffer do
  let(:product_catalogue) { ProductCatalogue.new }

  describe "#discount_for" do
    it "does not discount R01 when there is less than thresold quantity (2)" do
      offer = described_class.new(product_code: "R01", every_nth_item: 2, discount_percentage: 50)

      expect(offer.discount_for(["R01"], product_catalogue)).to eq(0)
    end

    it "discounts R01 when thresold quantity (2) is met" do
      offer = described_class.new(product_code: "R01", every_nth_item: 2, discount_percentage: 50)

      expect(offer.discount_for(["R01", "R01"], product_catalogue)).to eq(1648)
    end

    it "rejects invalid product codes and discount configurations" do
      expect {
        described_class.new(
          product_code: "B01",
          every_nth_item: 3,
          discount_percentage: 50
        )
      }.to raise_error(ArgumentError, "Offer is not valid on current product selection")
    end

    it "rejects invalid discounts for R01" do
      expect {
        described_class.new(
          product_code: "R01",
          every_nth_item: 3,
          discount_percentage: 100
        )
      }.to raise_error(ArgumentError, "Offer is not valid on current product selection")
    end
  end
end
