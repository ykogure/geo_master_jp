module GeoMasterJp
  class Station < ActiveRecord::Base
    self.table_name = 'geo_master_jp_stations'

    belongs_to :line, class_name: 'GeoMasterJp::Line', foreign_key: :geo_master_jp_line_code, primary_key: :code
    has_many :same_stations, class_name: 'GeoMasterJp::Station', foreign_key: :group_code, primary_key: :group_code
    has_many :station_connections, class_name: 'GeoMasterJp::StationConnection', foreign_key: :geo_master_jp_station_1_code, primary_key: :code
    has_many :neighbors, class_name: 'GeoMasterJp::Station', through: :station_connections, source: :station_2

    if GeoMasterJp.config.use_models.include?(:area)
      belongs_to :prefecture, class_name: 'GeoMasterJp::Prefecture', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
    end

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }

    def neighbor_station_codes
      station_connections.pluck(:geo_master_jp_station_2_code)
    end

    def self.inherited(child)
      child.belongs_to :line,          class_name: GeoMasterJp.config.alternative_class_name(:line),    foreign_key: :geo_master_jp_line_code, primary_key: :code
      child.has_many   :same_stations, class_name: GeoMasterJp.config.alternative_class_name(:station), foreign_key: :group_code,              primary_key: :group_code

      if GeoMasterJp.config.use_models.include?(:area)
        child.belongs_to :prefecture, class_name: GeoMasterJp.config.alternative_class_name(:prefecture), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
      end

      super
    end

    def self.select_options(transactions=nil)
      (transactions || all).map{|station| [station.name, line.code] }
    end
  end
end
