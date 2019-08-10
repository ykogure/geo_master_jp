module GeoMasterJp
  class Station < ActiveRecord::Base
    self.table_name = 'geo_master_jp_stations'

    belongs_to :line, class_name: 'GeoMasterJp::Line', foreign_key: :geo_master_jp_line_id
    has_many :same_stations, class_name: 'GeoMasterJp::Station', foreign_key: :group_code, primary_key: :group_code
    # has_many :connections, class_name: 'GeoMasterJp::StationConnection', foreign_key: :geo_master_jp_line_id

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }
  end
end
