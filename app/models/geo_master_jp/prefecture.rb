module GeoMasterJp
  class Prefecture < ActiveRecord::Base
    self.table_name = 'geo_master_jp_prefectures'

    has_many :cities, class_name: 'GeoMasterJp::City', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
    has_many :towns,  class_name: 'GeoMasterJp::Town', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code

    def head_kana
      return '' if self.name_kana.blank?
      head_kanas = ['ア', 'カ', 'サ', 'タ', 'ナ', 'ハ', 'マ', 'ヤ', 'ラ', 'ワ']
      head_kanas[head_kanas.index{|i| i > self.name_kana[0] }.to_i - 1]
    end

    def self.inherited(child)
      child.has_many :cities, class_name: GeoMasterJp.config.alternative_class_name(:city), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
      child.has_many :towns,  class_name: GeoMasterJp.config.alternative_class_name(:town), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code

      super
    end

    def city_select_options
      self.cities.map{|city| [city.name, city.code] }
    end

    def self.select_options(transactions=nil)
      (transactions || all).map{|prefecture| [prefecture.name, prefecture.code] }
    end
  end
end
