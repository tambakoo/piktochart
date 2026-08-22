# frozen_string_literal: true

RSpec.describe ProductCatalogue do
  describe "#price_for" do
    it "returns the price for a known product code" do
      catalogue = described_class.new

      expect(catalogue.price_for("R01")).to eq(3295)
    end

    it "raises an error for an unknown product code" do
      catalogue = described_class.new

      expect { catalogue.price_for("ABC") }.to raise_error(ArgumentError, "Unknown product code: ABC")
    end

    it "supports custom catalogue data" do
      catalogue = described_class.new("Y01" => 1295)

      expect(catalogue.price_for("Y01")).to eq(1295)
    end
  end

  describe "#initialize" do
    it "rejects blank product codes" do
      expect { described_class.new("" => 1295) }.to raise_error(ArgumentError, "Product code cannot be blank")
    end

    it "rejects non-integer prices" do
      expect { described_class.new("Y01" => "1295") }
        .to raise_error(ArgumentError, "Price for product: Y01 must be a non-negative integer amount of cents")
    end

    it "rejects negative prices" do
      expect { described_class.new("Y01" => -1) }
        .to raise_error(ArgumentError, "Price for product: Y01 must be a non-negative integer amount of cents")
    end
  end
end
