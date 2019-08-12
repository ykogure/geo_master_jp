module GeoMasterJp
  class StationConnection < ActiveRecord::Base
    self.table_name = 'geo_master_jp_station_connections'

    belongs_to :line,      class_name: GeoMasterJp.config.alternative_class_name(:line),    foreign_key: :geo_master_jp_line_id
    belongs_to :station_1, class_name: GeoMasterJp.config.alternative_class_name(:station), foreign_key: :geo_master_jp_station_1_id
    belongs_to :station_2, class_name: GeoMasterJp.config.alternative_class_name(:station), foreign_key: :geo_master_jp_station_2_id
  end
end
