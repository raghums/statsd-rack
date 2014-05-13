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
      use StatsdRack::Rack "myapp" # Will namespace statsd metric with 'myapp'
      ...
    end
  end
```
(Optional) If you set the `env['API']` parameter inside your application, the time taken and the counter for the API will be tracked

```ruby
  YourApp::App.controllers :yourcontroller do
    get :index do
      env['API'] = "getStuff"
      ...
    end
    ...
  end
```

## Usage - Rails

Edit your config/application.rb file:

```ruby
  module YourApp
    class Application < Rails::Application
      config.middleware.use StatsdRack::Rack, 'yourapp'
      ...
    end
  end
```

(Optional) If you set the `env['API']` parameter inside your application, the time taken and the counter for the API will be tracked

```ruby
  YourController < ApplicationController
    def index
      request.env['API'] = "getStuff"
      ...
    end
    ...
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
