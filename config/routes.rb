GeoMasterJp::Engine.routes.draw do
  if GeoMasterJp.config.use_apis.include?(:area)
    scope :api, as: 'api' do
      get 'prefectures', to: 'area_api#prefectures'
      get 'cities', to: 'area_api#cities'
      get 'towns', to: 'area_api#towns'
    end
  end

  if GeoMasterJp.config.use_apis.include?(:railway)
    scope :api, as: 'api' do
      get 'railway_companies', to: 'railway_api#railway_companies'
      get 'lines', to: 'railway_api#lines'
      get 'stations', to: 'railway_api#stations'
      get 'same_stations', to: 'railway_api#same_stations'
    end
  end
end
