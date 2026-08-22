# frozen_string_literal: true

class Basket
  def initialize(product_catalogue:, delivery_rules:, offers: [])
    @product_catalogue = product_catalogue
    @delivery_rules = delivery_rules
    @offers = offers
    @product_codes = []
  end

  def add(product_code)
    @product_catalogue.price_for(product_code)
    @product_codes << product_code.to_s
    self
  end

  def total
    return format_cents(0) if @product_codes.empty?

    current_subtotal_cents = subtotal_cents
    discounted_subtotal_cents = current_subtotal_cents - discount_cents
    delivery_charge_cents = @delivery_rules.charge_for(discounted_subtotal_cents)
    total_cents = discounted_subtotal_cents + delivery_charge_cents

    format_cents(total_cents)
  end

  # NOTE: need a way to peek into the basket
  # without exposing instance mutability
  def product_codes
    @product_codes.dup
  end

  private

  def subtotal_cents
    @product_codes.sum { |product_code| @product_catalogue.price_for(product_code) }
  end

  def discount_cents
    @offers.sum { |offer| offer.discount_for(@product_codes, @product_catalogue) }
  end

  def format_cents(amount_cents)
    dollars = amount_cents / 100
    cents = amount_cents % 100
    cents = "0#{cents}" if cents < 10

    "$#{dollars}.#{cents}"
  end
end
