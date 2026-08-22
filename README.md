# Widget Basket

Ruby implementation for the Acme Widget Co basket pricing.

The basket supports:

- product lookup through a catalogue
- delivery charges calculation based on basket subtotal
- discount offer strategies
- totals formatted as dollar amounts

## Setup

This POC was bundled with Ruby 4.0.5.
Requires Ruby 3.3+

```bash
bundle install
```

## Tests

This POC has a combination of unit tests and regression tests based on the supplied specifications pdf file. Tests can be run with 

```bash
bundle exec rspec
```

## Usage

```bash
cd <POC root>
irb -Ilib
```

```ruby
require "basket"
require "product_catalogue"
require "delivery_rules"
require "product_quantity_discount_offer"

product_catalogue = ProductCatalogue.new
delivery_rules = DeliveryRules.new
offers = [
  ProductQuantityDiscountOffer.new(
    product_code: "R01",
    every_nth_item: 2,
    discount_percentage: 50
  )
]

basket = Basket.new(
  product_catalogue: product_catalogue,
  delivery_rules: delivery_rules,
  offers: offers
)

basket.add("R01")
basket.add("R01")
basket.total
# => "$54.37"
```

## Design

`Basket` coordinates pricing but does not own pricing, delivery, or discount logic. The logic and validation for those live in `ProductCatalogue`, `DeliveryRules`, and `ProductQuantityDiscountOffer` classes.

`ProductQuantityDiscountOffer` is based on current offer strategy. It only accepts whitelisted quantity discount configurations. The initial supported offer is: buy one red widget (`R01`), get the second red widget half price.

Money is represented internally as integer cents to avoid floating point precision issues.

## Assumptions

- Empty baskets return `"$0.00"` and do not receive a delivery charge.
- Delivery charges are calculated after product discounts are applied.
- Half-cent discount results are truncated through integer arithmetic.
- `Basket#add` raises an `ArgumentError` when the product catalogue cannot find a product code.