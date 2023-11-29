module GeoMasterJp
  class Line < ActiveRecord::Base
    self.table_name = 'geo_master_jp_lines'

    belongs_to :railway_company, class_name: 'GeoMasterJp::RailwayCompany', foreign_key: :geo_master_jp_railway_company_code, primary_key: :code
    has_many   :stations,        class_name: 'GeoMasterJp::Station',        foreign_key: :geo_master_jp_line_code,            primary_key: :code

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }

    def self.inherited(child)
      child.belongs_to :railway_company, class_name: GeoMasterJp.config.alternative_class_name(:railway_company), foreign_key: :geo_master_jp_railway_company_code, primary_key: :code
      child.has_many   :stations,        class_name: GeoMasterJp.config.alternative_class_name(:station),         foreign_key: :geo_master_jp_line_code,            primary_key: :code

      super
    end
  end
end
