require "geo_master_jp/railtie"
require "geo_master_jp/engine"
require "geo_master_jp/association_helper"

module GeoMasterJp
  # Your code goes here...
end

ActiveRecord::Base.send :include, GeoMasterJp::AssociationHelper
