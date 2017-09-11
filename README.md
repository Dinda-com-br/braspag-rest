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

### Configuration

The gem looks for a default `config/braspag-rest.yml` configuration file, with
environment (`RACK_ENV` or `RAILS_ENV`) settings for the Braspag API.

```yml
# config/braspag-rest.yml
development:
  url: 'https://apisandbox.braspag.com.br'
  query_url: 'https://apiquerysandbox.braspag.com.br'
  merchant_id: 'Your MerchantId here'
  merchant_key: 'Your MerchantKey here'
  request_timeout: 60
```

If you want to use a different file or manually set which environment should be
used, you can create an initializer file and use the `BraspagRest.config` method
to set your config.

```ruby
# config/initializers/braspag-rest.rb
BraspagRest.config do |config|
  config.config_file_path = 'config/path/here.yml'
  config.enviroment = 'production'
end
```

You can use ERB blocks to interpolate values from your environment variables into
the configuration if you are using something like [dotenv](https://github.com/bkeepers/dotenv)
to handle configuration values that shouldn't be present in the source code.

```yml
# config/braspag-rest.yml
development:
  url: 'https://apisandbox.braspag.com.br'
  query_url: 'https://apiquerysandbox.braspag.com.br'
  merchant_id: 'Your MerchantId here'
  merchant_key: 'Your MerchantKey here'
  request_timeout: 60
production:
  url: <%= ENV['BRASPAG_URL'] %>
  query_url: <%= ENV['BRASPAG_QUERY_URL'] %>
  merchant_id: <%= ENV['BRASPAG_MERCHANT_ID'] %>
  merchant_key: <%= ENV['BRASPAG_MERCHANT_KEY'] %>
  request_timeout: <%= ENV['BRASPAG_REQUEST_TIMEOUT'] %>
```

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

### Authorize an order support fraud analysis fields

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
    fraud_analysis: {
      sequence: 'AuthorizeFirst',
      sequence_criteria: 'Always',
      capture_on_low_risk: false,
      void_on_high_risk: false,
      browser: {
        cookies_accepted: false,
        email: 'compradorteste@live.com',
        host_name: 'Teste',
        ip_address: '202.190.150.350',
        type: 'Chrome'
      },
      cart: {
        is_gift: false,
        returns_accepted: true,
        items: [
          {
            gift_category: 'Undefined',
            host_hedge: 'Off',
            non_sensical_hedge: 'Off',
            obscenities_hedge: 'Off',
            phone_hedge: 'Off',
            name: 'ItemTeste',
            quantity: 1,
            sku: '201411170235134521346',
            unit_price: 123,
            risk: 'High',
            time_hedge: 'Normal',
            type: 'AdultContent',
            velocity_hedge: 'High'
          }
        ]
      },
      merchant_defined_fields: [
        {
          id: 9,
          value: 'web'
        }
      ],
      shipping: {
        addressee: 'Sr Comprador Teste',
        method: 'LowCost',
        phone: '21114740'
      },
      travel: {
        departure_time: '2010-01-02',
        journey_type: 'Ida',
        route: 'MAO-RJO',
        legs: [{
          destination: 'GYN',
          origin: 'VCP'
        }]
      }
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

### Find a sale

```rb
sale = BraspagRest::Sale.find('REQUEST_ID', 'PAYMENT_ID')
sale.customer.name
=> "Maria"
```

### Find sales for a store, aka: MerchantOrderId

```rb
sales = BraspagRest::Sale.find_by_order_id('REQUEST_ID', 'MERCHANT_ORDER_ID')
sales.map { |sale| sale.customer.name }
=> ["Maria", "Joana"]
```

### Cancel a sale

```rb
sale = BraspagRest::Sale.find('REQUEST_ID', 'PAYMENT_ID')
sale.cancel

sale.voided_amount
=> 30017

sale.voided_date
=> "2017-09-11 16:53:03"

sale.payment.refunds
=> [{:amount=>30017, :status=>3, :received_date=>"2017-09-11T16:53:03.407"}]
```

### Capture a sale

```rb
sale = BraspagRest::Sale.find('REQUEST_ID', 'PAYMENT_ID')
sale.capture
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Dinda-com-br/braspag-rest.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
