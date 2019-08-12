module GeoMasterJp
  class RailwayCompany < ActiveRecord::Base
    self.table_name = 'geo_master_jp_railway_companies'

    has_many :lines, class_name: GeoMasterJp.config.alternative_class_name(:line), foreign_key: :geo_master_jp_railway_company_id

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }
  end
end
