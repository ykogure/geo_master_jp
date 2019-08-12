require 'geo_master_jp/config'
require 'geo_master_jp/models/prefecture'
require 'geo_master_jp/models/city'
require 'geo_master_jp/models/town'
require 'geo_master_jp/models/railway_company'
require 'geo_master_jp/models/line'
require 'geo_master_jp/models/station'
require 'geo_master_jp/models/station_connection'
require 'geo_master_jp/models/version'

require 'active_record'
require 'activerecord-import'

module GeoMasterJp
  def self.config
    @config ||= GeoMasterJp::Config.new
  end

  def self.configure(&block)
    yield(config) if block_given?
  end
end
