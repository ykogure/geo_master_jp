module GeoMasterJp
  class AreaApiController < ApplicationController
    def prefectures
      prefectures = GeoMasterJp::Prefecture.all

      render json: {
        prefectures: prefectures.map{|prefecture|
          prefecture.as_json(only: [:code, :name, :name_kana, :name_alphabet, :short_name])
        },
        initials: prefectures.group_by(&:head_kana).sort_by(&:first).to_h
      }
    end

    def cities
      if params[:prefecture_code].blank?
        return render json: {
          message: 'prefecture_code is required.'
        }, status: 400
      end

      cities = GeoMasterJp::Prefecture.find_by(code: params[:prefecture_code]).cities

      render json: {
        cities: cities.map{|city|
          city.as_json(only: [:code, :name, :name_kana, :name_alphabet, :short_name])
        },
        initials: cities.group_by(&:head_kana).sort_by(&:first).to_h
      }
    end

    def towns
      if params[:city_code].blank?
        return render json: {
          message: 'city_code is required.'
        }, status: 400
      end

      towns = GeoMasterJp::City.find_by(code: params[:city_code]).towns

      render json: {
        towns: towns.map{|town|
          town.as_json(only: [:zip_code, :code, :name, :name_kana, :name_alphabet, :short_name])
        },
        initials: towns.group_by(&:head_kana).sort_by(&:first).to_h
      }
    end
  end
end
