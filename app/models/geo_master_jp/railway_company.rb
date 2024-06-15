module GeoMasterJp
  class RailwayCompany < ActiveRecord::Base
    self.table_name = 'geo_master_jp_railway_companies'

    has_many :lines, class_name: 'GeoMasterJp::Line', foreign_key: :geo_master_jp_railway_company_code, primary_key: :code

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
      child.has_many :lines, class_name: GeoMasterJp.config.alternative_class_name(:line), foreign_key: :geo_master_jp_railway_company_code, primary_key: :code

      super
    end

    def line_select_options
      self.lines.map{|line| [line.name, line.code] }
    end

    def self.select_options(transactions=nil)
      (transactions || all).map{|railway_company| [railway_company.name, railway_company.code] }
    end
  end
end
