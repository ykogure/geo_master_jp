GeoMasterJp.configure do |config|
  # Alternative Class Names
  # config.alternative_class_names = {
  #   prefecture:         'Prefecture',
  #   city:               'City',
  #   town:               'Town',
  #   railway_company:    'RailwayCompany',
  #   line:               'line',
  #   station:            'Station',
  #   station_connection: 'StationConnection'
  # }

  # Use Models
  # config.use_models = [:area, :railway]

  # Use APIs
  # config.use_apis = [:area, :railway]

  # API Filters
  # config.api.prefectures_filter = ->(prefectures) {
  #   prefecture_codes = ['11', '12', '13', '14']
  #   prefectures.select { |prefecture| prefecture.code.in?(prefecture_codes) }
  # }
  # config.api.cities_filter = ->(cities) {
  # }
  # config.api.towns_filter = ->(towns) {
  # }
end
