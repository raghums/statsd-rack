# Statsd::Rack

This gem initializes a global variable `$statsd` that can be used pump metrics to a statsd server. Inspired by [rack-statsd](https://github.com/github/rack-statsd).

## Installation

Add this line to your application's Gemfile:

    gem 'statsd-rack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statsd-rack

## Usage - Padrino

Edit your app.rb file

```ruby
  module YourApp
    class App < Padrino::Application
      use Statsd::Rack "myapp" # Will namespace statsd metric with 'myapp'
      ...
    end
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
