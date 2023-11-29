GeoMasterJp::Engine.routes.draw do
  scope :api, as: 'api' do
    get 'prefectures', to: 'area_api#prefectures'
    get 'cities', to: 'area_api#cities'
    get 'towns', to: 'area_api#towns'
  end
end
