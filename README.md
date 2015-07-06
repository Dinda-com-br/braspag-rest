# BraspagRest

[![Travis-CI](https://travis-ci.org/Dinda-com-br/braspag-rest.svg?branch=master)](https://travis-ci.org/Dinda-com-br/braspag-rest)

Gem to use Braspag gateway in his REST version.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'braspag-rest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install braspag-rest

## Usage

### Authorize an order

```rb
sale = BraspagRest::Sale.new(
  order_id: '123456',
  request_id: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
  customer: {
    name: 'Comprador Teste'
  },
  payment: {
    type: 'CreditCard',
    amount: 15700,
    provider: 'Simulado',
    installments: 1,
    credit_card: {
      number: '0000000000000001',
      holder: 'Teste Holder',
      expiration_date: '12/2021',
      security_code: '123',
      brand: 'Visa'
    }
  }
)

sale.save
```

And to create a protected credit card, you should set the credit card saved as true:

```rb
credit_card = BraspagRest::CreditCard.new
credit_card.number = '0000000000000001'
credit_card.holder = 'Teste Holder'
credit_card.expiration_date = '12/2021'
credit_card.security_code = '123'
credit_card.brand = 'Visa'
credit_card.saved = true
```

### Cancel an sale

```rb
sale = BraspagRest::Sale.new(
  request_id: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
  payment: {
    id: 'yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy',
    amount: 100
  }
)

sale.cancel
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Dinda-com-br/braspag-rest.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

