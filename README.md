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

## Smart Caching

`sinatra-static` is meant as a smarter tool for serving static assets within Sinatra:

- It will always send the header `cache_control(:public, :immutable, { max_age: 31536000 })` for every static asset requested.
- It will automatically disable the static file serving functionality built into Sinatra.
- It will reuse the same `:public_folder` configuration option provided by Sinatra to find your static assets (by default this is `public/`).

### In Production (`APP_ENV=production`)

- `sinatra-static` checks and stores in memory the `mtime` of each static asset when it's first requested.  It then appends that `mtime` value to the assets URL.  As long as you haven't modified the file, this URL won't change, and any client that has already requested the asset will continue to use the cached version.  As soon as you modify the file and restart your server, the `mtime` (and, subsequently, the URL) will change, and clients will download the new version.  This gives you optimal control over having clients only request an asset once upon change.

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

In any erb file there are helper functions you can use to generate the proper markup for each type of static asset:

- CSS:

```erb
<%= css('index') %>
```

- Any generic `<link rel=... href=... />` tag (such as for a `favicon`):

```erb
<%= rel('favicon.ico', 'icon') %>
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
