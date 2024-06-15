module GeoMasterJp
  class Prefecture < ActiveRecord::Base
    self.table_name = 'geo_master_jp_prefectures'

    has_many :cities, class_name: 'GeoMasterJp::City', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
    has_many :towns,  class_name: 'GeoMasterJp::Town', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code

    if GeoMasterJp.config.use_models.include?(:railway)
      has_many :stations, class_name: 'GeoMasterJp::Station', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
      has_many :prefectures_lines, class_name: 'GeoMasterJp::PrefecturesLine', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
      has_many :lines, through: :prefectures_lines
    end

    def head_kana
      return '' if self.name_kana.blank?
      head_kanas = ['ア', 'カ', 'サ', 'タ', 'ナ', 'ハ', 'マ', 'ヤ', 'ラ', 'ワ']
      head_kanas[head_kanas.index{|i| i > self.name_kana[0] }.to_i - 1]
    end

    def self.inherited(child)
      child.has_many :cities, class_name: GeoMasterJp.config.alternative_class_name(:city), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
      child.has_many :towns,  class_name: GeoMasterJp.config.alternative_class_name(:town), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code

      if GeoMasterJp.config.use_models.include?(:railway)
        child.has_many :stations, class_name: GeoMasterJp.config.alternative_class_name(:station), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
        child.has_many :prefectures_lines, class_name: GeoMasterJp.config.alternative_class_name(:prefectures_line), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
        child.has_many :lines, through: :prefectures_lines, class_name: GeoMasterJp.config.alternative_class_name(:line)
      end

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
