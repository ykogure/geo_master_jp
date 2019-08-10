module GeoMasterJp
  module AssociationHelper
    extend ActiveSupport::Concern

    class_methods do
      def has_one_geo_master(key)
        belongs_to key, class_name: "GeoMasterJp::#{key.camelize}", foreign_key: :"geo_master_jp_#{key}_code", primary_key: :code
      end
      def belongs_to_geo_master(key)
        belongs_to key, class_name: "GeoMasterJp::#{key.camelize}", foreign_key: :"geo_master_jp_#{key}_code", primary_key: :code
      end
    end
  end
end
