module GeoMasterJp
  class Line < ActiveRecord::Base
    self.table_name = 'geo_master_jp_lines'

    belongs_to :railway_company, class_name: 'GeoMasterJp::RailwayCompany', foreign_key: :geo_master_jp_railway_company_id
    has_many :stations, class_name: 'GeoMasterJp::Station', foreign_key: :geo_master_jp_line_id

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }
  end
end