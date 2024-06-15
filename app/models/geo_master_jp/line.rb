module GeoMasterJp
  class Line < ActiveRecord::Base
    self.table_name = 'geo_master_jp_lines'

    belongs_to :railway_company, class_name: 'GeoMasterJp::RailwayCompany', foreign_key: :geo_master_jp_railway_company_code, primary_key: :code
    has_many   :stations,        class_name: 'GeoMasterJp::Station',        foreign_key: :geo_master_jp_line_code,            primary_key: :code

    if GeoMasterJp.config.use_models.include?(:area)
      has_many :prefectures_lines, class_name: 'GeoMasterJp::PrefecturesLine', foreign_key: :geo_master_jp_line_code, primary_key: :code
      has_many :prefectures, through: :prefectures_lines, class_name: 'GeoMasterJp::Prefecture'
    end

    enum status: {
      running:  0,
      will_run: 1,
      deleted:  2
    }

    def head_kana
      return '' if self.name_kana.blank?
      head_kanas = ['ア', 'カ', 'サ', 'タ', 'ナ', 'ハ', 'マ', 'ヤ', 'ラ', 'ワ']
      head_kanas[head_kanas.index{|i| i > self.name_kana[0] }.to_i - 1]
    end

    def self.inherited(child)
      child.belongs_to :railway_company, class_name: GeoMasterJp.config.alternative_class_name(:railway_company), foreign_key: :geo_master_jp_railway_company_code, primary_key: :code
      child.has_many   :stations,        class_name: GeoMasterJp.config.alternative_class_name(:station),         foreign_key: :geo_master_jp_line_code,            primary_key: :code

      if GeoMasterJp.config.use_models.include?(:area)
        child.has_many :prefectures_lines, class_name: GeoMasterJp.config.alternative_class_name(:prefectures_line), foreign_key: :geo_master_jp_line_code, primary_key: :code
        child.has_many :prefectures, through: :prefectures_lines, class_name: GeoMasterJp.config.alternative_class_name(:prefecture)
      end

      super
    end

    def station_select_options
      self.stations.map{|station| [station.name, station.code] }
    end

    def self.select_options(transactions=nil)
      (transactions || all).map{|line| [line.name, line.code] }
    end
  end
end
