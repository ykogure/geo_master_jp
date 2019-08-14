module GeoMasterJp
  class Station < ActiveRecord::Base
    self.table_name = 'geo_master_jp_stations'

    belongs_to :line, class_name: 'GeoMasterJp::Line', foreign_key: :geo_master_jp_line_id
    has_many :same_stations, class_name: 'GeoMasterJp::Station', foreign_key: :group_code, primary_key: :group_code
    # has_many :connections, class_name: GeoMasterJp.config.alternative_class_name(:station_connection), foreign_key: :geo_master_jp_line_id

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }

    def self.inherited(child)
      child.belongs_to :line, class_name: GeoMasterJp.config.alternative_class_name(:line), foreign_key: :geo_master_jp_line_id
      child.has_many :same_stations, class_name: GeoMasterJp.config.alternative_class_name(:station), foreign_key: :group_code, primary_key: :group_code

      super
    end
  end
end
