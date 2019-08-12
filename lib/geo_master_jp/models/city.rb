module GeoMasterJp
  class City < ActiveRecord::Base
    self.table_name = 'geo_master_jp_cities'

    belongs_to :prefecture, class_name: GeoMasterJp.config.alternative_class_name(:prefecture), foreign_key: :geo_master_jp_prefecture_id
    has_many :towns, class_name: GeoMasterJp.config.alternative_class_name(:town), foreign_key: :geo_master_jp_city_id

    def head_kana
      return '' if self.name_kana.blank?
      head_kanas = ['ア', 'カ', 'サ', 'タ', 'ナ', 'ハ', 'マ', 'ヤ', 'ラ', 'ワ']
      head_kanas[head_kanas.index{|i| i > self.name_kana[0] }.to_i - 1]
    end
  end
end
