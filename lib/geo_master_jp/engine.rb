require 'geo_master_jp/config'
module GeoMasterJp
  def self.config
    @config ||= GeoMasterJp::Config.new
  end

  def self.configure(&block)
    yield(config) if block_given?
  end
end

if GeoMasterJp.config.use_models.include?(:area)
  require 'geo_master_jp/models/prefecture'
  require 'geo_master_jp/models/city'
  require 'geo_master_jp/models/town'
end
if GeoMasterJp.config.use_models.include?(:railway)
  require 'geo_master_jp/models/railway_company'
  require 'geo_master_jp/models/line'
  require 'geo_master_jp/models/station'
  require 'geo_master_jp/models/station_connection'
end
require 'geo_master_jp/models/version'

require 'active_record'
require 'activerecord-import'

