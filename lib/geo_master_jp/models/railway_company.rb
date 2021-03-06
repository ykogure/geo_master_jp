module GeoMasterJp
  class RailwayCompany < ActiveRecord::Base
    self.table_name = 'geo_master_jp_railway_companies'

    has_many :lines, class_name: 'GeoMasterJp::Line', foreign_key: :geo_master_jp_railway_company_code, primary_key: :code

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }

    def self.inherited(child)
      child.has_many :lines, class_name: GeoMasterJp.config.alternative_class_name(:line), foreign_key: :geo_master_jp_railway_company_code, primary_key: :code

      super
    end
  end
end
