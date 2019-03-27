module GeoMasterJp
  class Town < ActiveRecord::Base
    self.table_name = 'geo_master_jp_towns'

    belongs_to :prefecture, class_name: 'GeoMasterJp::Prefecture', foreign_key: :geo_master_jp_prefecture_id
    belongs_to :city, class_name: 'GeoMasterJp::City', foreign_key: :geo_master_jp_city_id
  end
end
