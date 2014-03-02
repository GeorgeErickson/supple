# Supple
Rails elasticsearch integration with no magic.

## Setup
```ruby
Supple.configure do |config|
  config.pool_size = 5
  config.pool_timeout = 1
  config.index_name = -> { table_name }
end
```
