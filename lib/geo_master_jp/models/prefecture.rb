module GeoMasterJp
  class Prefecture < ActiveRecord::Base
    self.table_name = 'geo_master_jp_prefectures'

    has_many :cities, class_name: 'GeoMasterJp::City', foreign_key: :geo_master_jp_prefecture_id
    has_many :towns, class_name: 'GeoMasterJp::Town', foreign_key: :geo_master_jp_prefecture_id

    def head_kana
      return '' if self.name_kana.blank?
      head_kanas = ['ア', 'カ', 'サ', 'タ', 'ナ', 'ハ', 'マ', 'ヤ', 'ラ', 'ワ']
      head_kanas[head_kanas.index{|i| i > self.name_kana[0] }.to_i - 1]
    end
  end
end
