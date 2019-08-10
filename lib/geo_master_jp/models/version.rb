module GeoMasterJp
  class Version < ActiveRecord::Base
    self.table_name = 'geo_master_jp_versions'

    def model
      self.model_name_string.constantize
    end

    class << self
      def last_version(klass)
        last_data = where(model_name_string: klass.to_s).order('version ASC').last
        last_data ? last_data.version : nil
      end
    end
  end
end
