# frozen_string_literal: true

class ProductCatalogue
  # INFO: product code and price cents
  DEFAULT_PRODUCTS = {
    'R01' => 3295,
    'G01' => 2495,
    'B01' => 795
  }.freeze

  def initialize(products = DEFAULT_PRODUCTS)
    catalogue = {}
    products.each do |code, price_cents|
      validate_product!(code, price_cents)
      catalogue[code.to_s] = price_cents
    end

    @products = catalogue.freeze
  end

  def price_for(product_code)
    code = product_code.to_s

    @products.fetch(code) do
      raise ArgumentError, "Unknown product code: #{code}"
    end
  end

  private

  def validate_product!(code, price_cents)
    raise ArgumentError, 'Product code cannot be blank' if code.to_s.empty?

    return if price_cents.is_a?(Integer) && price_cents >= 0

    raise ArgumentError, "Price for product: #{code} must be a non-negative integer amount of cents"
  end
end
