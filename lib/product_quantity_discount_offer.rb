# frozen_string_literal: true

class ProductQuantityDiscountOffer
  ALLOWED_OFFERS = [
    {
      product_code: "R01",
      every_nth_item: 2,
      discount_percentage: 50
    }
  ].freeze

  def initialize(product_code:, every_nth_item:, discount_percentage:)
    @product_code = product_code.to_s
    @every_nth_item = every_nth_item
    @discount_percentage = discount_percentage

    validate_offer!
  end

  def discount_for(product_codes, product_catalogue)
    discounted_items_count = product_codes.count(@product_code) / @every_nth_item
    return 0 if discounted_items_count.zero?

    full_price_cents = product_catalogue.price_for(@product_code)
    discount_cents = (full_price_cents * @discount_percentage) / 100
    discounted_price_cents = full_price_cents - discount_cents

    discounted_items_count * discounted_price_cents
  end

  private

  def validate_offer!
    return if offer_exists?

    raise ArgumentError, "Offer is not valid on current product selection"
  end

  def offer_exists?
    ALLOWED_OFFERS.any? do |offer|
      offer.fetch(:product_code) == @product_code &&
        offer.fetch(:every_nth_item) == @every_nth_item &&
        offer.fetch(:discount_percentage) == @discount_percentage
    end
  end
end
