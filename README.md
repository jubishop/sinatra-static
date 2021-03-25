# sinatra-static

Cache-smart serving of static assets for Sinatra.

## Installation

This gem can be found at https://www.jubigems.org/gems/sinatra-static

### Global installation

```zsh
gem install sinatra-static --source https://www.jubigems.org/
```

### In a Gemfile

```ruby
gem 'sinatra-static', source: 'https://www.jubigems.org/'
```

## Usage

In your main file:

```ruby
require 'sinatra/static'

class MyApp < Sinatra::Base
  register Sinatra::Static
end
```

In an erb file:

```ruby
<%= static('favicon.ico', 'icon') %>
<%= css('index') %>
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
