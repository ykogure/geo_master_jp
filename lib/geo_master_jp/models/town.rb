module GeoMasterJp
  class Town < ActiveRecord::Base
    self.table_name = 'geo_master_jp_towns'

    belongs_to :prefecture, class_name: 'GeoMasterJp::Prefecture', foreign_key: :geo_master_jp_prefecture_id
    belongs_to :city, class_name: 'GeoMasterJp::City', foreign_key: :geo_master_jp_city_id

    def head_kana
      return '' if self.name_kana.blank?
      head_kanas = ['ア', 'カ', 'サ', 'タ', 'ナ', 'ハ', 'マ', 'ヤ', 'ラ', 'ワ']
      head_kanas[head_kanas.index{|i| i > self.name_kana[0] }.to_i - 1]
    end

    def self.inherited(child)
      child.belongs_to :prefecture, class_name: GeoMasterJp.config.alternative_class_name(:prefecture), foreign_key: :geo_master_jp_prefecture_id
      child.belongs_to :city, class_name: GeoMasterJp.config.alternative_class_name(:city), foreign_key: :geo_master_jp_city_id

      super
    end
  end
end
