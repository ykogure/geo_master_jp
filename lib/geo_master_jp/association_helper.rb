module GeoMasterJp
  module AssociationHelper
    extend ActiveSupport::Concern

    class_methods do
      def has_one_geo_master(key)
        belongs_to key, class_name: "GeoMasterJp::#{key.to_s.camelize}", foreign_key: :"geo_master_jp_#{key}_code", primary_key: :code
      end
      alias_method :belongs_to_geo_master, :has_one_geo_master
    end
  end
end
