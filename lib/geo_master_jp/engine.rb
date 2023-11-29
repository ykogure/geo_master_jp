module GeoMasterJp
  # GeoMasterJp用のroutingを設定する。
  class Engine < ::Rails::Engine
    isolate_namespace GeoMasterJp
  end
  def self.set_routes(rails_router)
    rails_router.mount Engine, at: '/geo_master_jp'
  end
end

require 'active_record'
require 'activerecord-import'
