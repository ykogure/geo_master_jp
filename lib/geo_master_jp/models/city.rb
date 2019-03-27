module GeoMasterJp
  class City < ActiveRecord::Base
    self.table_name = 'geo_master_jp_cities'

    belongs_to :prefecture, class_name: 'GeoMasterJp::Prefecture', foreign_key: :geo_master_jp_prefecture_id
    has_many :towns, class_name: 'GeoMasterJp::Town', foreign_key: :geo_master_jp_city_id
  end
end
