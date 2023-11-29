module GeoMasterJp
  def self.config
    @config ||= GeoMasterJp::Config.new
  end

  def self.configure(&block)
    yield(config) if block_given?
  end

  class Config
    # Variables detail is writen in lib/generators/templates/geo_master_jp.rb.
    attr_accessor :alternative_class_names, :use_models

    def initialize
      @alternative_class_names = {}
      @use_models = [:area, :railway]
    end

    def alternative_class_name(key)
      @alternative_class_names[key] || "GeoMasterJp::#{key.to_s.camelize}"
    end
  end
end
