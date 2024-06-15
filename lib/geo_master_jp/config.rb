module GeoMasterJp
  def self.config
    @config ||= GeoMasterJp::Config.new
  end

  def self.configure(&block)
    yield(config) if block_given?
  end

  class Config
    # Variables detail is writen in lib/generators/templates/geo_master_jp.rb.
    attr_accessor :alternative_class_names, :use_models, :use_apis, :api

    def initialize
      @alternative_class_names = {}
      @use_models = [:area, :railway]
      @use_apis = [:area, :railway]
      @api = API.new
    end

    def alternative_class_name(key)
      @alternative_class_names[key] || "GeoMasterJp::#{key.to_s.camelize}"
    end

    class API
      attr_accessor :prefectures_filter, :cities_filter, :towns_filter
    end
  end
end
