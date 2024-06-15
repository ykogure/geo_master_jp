module GeoMasterJp
  class AreaApiController < ApplicationController
    def prefectures
      prefectures = GeoMasterJp::Prefecture.all

      prefectures = GeoMasterJp.config.api.prefectures_filter.call(prefectures) if GeoMasterJp.config.api.prefectures_filter

      render json: {
        prefectures: prefectures.map{|prefecture|
          prefecture.as_json(only: [:code, :name, :name_kana, :name_alphabet, :short_name])
        },
        initials: prefectures.sort_by(&:name_kana).group_by(&:head_kana).sort_by(&:first).to_h
      }
    end

    def cities
      if params[:prefecture_code].blank?
        return render json: {
          message: 'prefecture_code is required.'
        }, status: 400
      end

      cities = GeoMasterJp::Prefecture.find_by(code: params[:prefecture_code]).cities

      cities = GeoMasterJp.config.api.cities_filter.call(cities) if GeoMasterJp.config.api.cities_filter

      render json: {
        cities: cities.map{|city|
          city.as_json(only: [:code, :name, :name_kana, :name_alphabet, :short_name])
        },
        initials: cities.sort_by(&:name_kana).group_by(&:head_kana).sort_by(&:first).to_h
      }
    end

    def towns
      if params[:city_code].blank?
        return render json: {
          message: 'city_code is required.'
        }, status: 400
      end

      towns = GeoMasterJp::City.find_by(code: params[:city_code]).towns

      towns = GeoMasterJp.config.api.towns_filter.call(towns) if GeoMasterJp.config.api.towns_filter

      render json: {
        towns: towns.map{|town|
          town.as_json(only: [:zip_code, :code, :name, :name_kana, :name_alphabet, :short_name])
        },
        initials: towns.sort_by(&:name_kana).group_by(&:head_kana).sort_by(&:first).to_h
      }
    end
  end
end
