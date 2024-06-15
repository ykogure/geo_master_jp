module GeoMasterJp
  class PrefecturesLine < ActiveRecord::Base
    self.table_name = 'geo_master_jp_prefectures_lines'

    belongs_to :prefecture, class_name: 'GeoMasterJp::Prefecture', foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
    belongs_to :line,       class_name: 'GeoMasterJp::Line',       foreign_key: :geo_master_jp_line_code,       primary_key: :code

    def self.inherited(child)
      child.belongs_to :prefecture, class_name: GeoMasterJp.config.alternative_class_name(:prefecture), foreign_key: :geo_master_jp_prefecture_code, primary_key: :code
      child.belongs_to :line,       class_name: GeoMasterJp.config.alternative_class_name(:line),       foreign_key: :geo_master_jp_line_code,       primary_key: :code

      super
    end
  end
end
