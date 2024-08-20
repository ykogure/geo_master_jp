module GeoMasterJp
  class City < ActiveRecord::Base
    self.table_name = 'geo_master_jp_cities'

    belongs_to :prefecture, class_name: 'GeoMasterJp::Prefecture', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
    has_many   :towns,      class_name: 'GeoMasterJp::Town',       foreign_key: :geo_master_jp_city_code,       primary_key: :code

    def head_kana
      return '' if self.name_kana.blank?
      head_kanas = ['ア', 'カ', 'サ', 'タ', 'ナ', 'ハ', 'マ', 'ヤ', 'ラ', 'ワ']
      head_kanas[head_kanas.index{|i| i > self.name_kana[0] }.to_i - 1]
    end

    def self.inherited(child)
      child.belongs_to :prefecture, class_name: GeoMasterJp.config.alternative_class_name(:prefecture), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
      child.has_many   :towns,      class_name: GeoMasterJp.config.alternative_class_name(:town),       foreign_key: :geo_master_jp_city_code,       primary_key: :code

      super
    end

    def town_select_options
      self.towns.map{|town| [town.name, town.code] }
    end

    def town_grouped_select_options
      self.towns.group_by(&:head_kana).map do |head_kana, towns|
        [head_kana, towns.map{|town| [town.name, town.code] }]
      end.sort_by{|head_kana, _| head_kana }
    end
  end
end
