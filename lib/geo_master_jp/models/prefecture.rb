module GeoMasterJp
  class Prefecture < ActiveRecord::Base
    self.table_name = 'geo_master_jp_prefectures'

    has_many :cities, class_name: 'GeoMasterJp::City', foreign_key: :geo_master_jp_prefecture_id
    has_many :towns, class_name: 'GeoMasterJp::Town', foreign_key: :geo_master_jp_prefecture_id
  end
end
