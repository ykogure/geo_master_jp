# WIP
This gem is WIP!

# GeoMasterJp
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'geo_master_jp'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install geo_master_jp
```

## Initialize
### Create Config File
```bash
rails g geo_master_jp:install
```

### Create Migration Files
```bash
rails g geo_master_jp:install_migration
```

### Import Area Data
```bash
rails g geo_master_jp:install_area_data
```

### Import Railway Data
```bash
rails g geo_master_jp:install_railway_data
```

*Area data is required as a prerequisite.

## Usage

### Use Area Data Examples

```ruby
prefectures = GeoMasterJp::Prefecture.all

tokyo = prefectures.find_by(code: '13')
cities = tokyo.cities

shinjuku = cities.find_by(code: '13104')
towns = shinjuku.towns
```

### Use Area Data API

Add the following line to your `config/routes.rb`:

```ruby
GeoMasterJp.set_routes(self)
```

Then you can use the following API:

- `/geo_master_jp/api/prefectures`
- `/geo_master_jp/api/cities?prefecture_code=13`
- `/geo_master_jp/api/towns?city_code=13104`

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
