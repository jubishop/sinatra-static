# sinatra-static

[![Rubocop Status](https://github.com/jubishop/sinatra-static/workflows/Rubocop/badge.svg)](https://github.com/jubishop/sinatra-static/actions)

Cache-smart serving of static assets for Sinatra.

## Installation

### Global installation

```zsh
gem install sinatra-static --source https://www.jubigems.org/
```

### In a Gemfile

```ruby
gem 'sinatra-static', source: 'https://www.jubigems.org/'
```

## Smart Caching

`sinatra-static` is meant as a smarter tool for serving static assets within Sinatra:

- It will always send the header `cache_control(:public, :immutable, { max_age: 31536000 })` for every static asset requested.
- It will automatically disable the static file serving functionality built into Sinatra.
- It will reuse the same `:public_folder` configuration option provided by Sinatra to find your static assets (by default this is `public/`).

### In Production (`APP_ENV=production`)

- `sinatra-static` checks and stores in memory the `mtime` of each static asset when it's first requested.  It then appends that `mtime` value to the asset's URL.  As long as you haven't modified the file, this URL won't change, and any client that has already requested the asset will continue to use the cached version.  As soon as you modify the file and restart your server, the `mtime` (and, subsequently, the URL) will change, and clients will download the new version.

### In Development (`APP_ENV=development`)

- `sinatra-static` simply appends the current Timestamp to every static asset URL, so that the browser always gets a new copy of the file.

## Usage

In your main file:

```ruby
require 'sinatra/static'

class MyApp < Sinatra::Base
  register Sinatra::Static
end
```

Then, for your view files (typically `.erb` files), `sinatra-static` provides the following methods with the same interface as those found in the [`AssetTagHelper`](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html) class in Ruby on Rails.

- [stylesheet_link_tag](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-stylesheet_link_tag)
- [favicon_link_tag](https://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-favicon_link_tag)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
