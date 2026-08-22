# frozen_string_literal: true

class DeliveryRules
  # NOTE: insert new rules in amount range order
  DEFAULT_CHARGES = [
    { order_amount_cents: 5_000, charge_cents: 495 },
    { order_amount_cents: 9_000, charge_cents: 295 },
    { order_amount_cents: nil, charge_cents: 0 }
  ].freeze

  def initialize(rules = DEFAULT_CHARGES)
    @rules = rules
  end

  def charge_for(subtotal_cents)
    validate_subtotal!(subtotal_cents)

    rule = @rules.find do |delivery_rule|
      rule_amount_cents = delivery_rule.fetch(:order_amount_cents)
      rule_amount_cents.nil? || subtotal_cents < rule_amount_cents
    end

    rule.fetch(:charge_cents)
  end

  private

  def validate_subtotal!(subtotal_cents)
    return if subtotal_cents.is_a?(Integer) && subtotal_cents >= 0

    raise ArgumentError, 'Subtotal must be a non-negative integer amount of cents'
  end
end
