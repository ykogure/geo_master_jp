module GeoMasterJp
  class RailwayApiController < ApplicationController
    def railway_companies
      railway_companies = GeoMasterJp::RailwayCompany.all

      if params[:status].present?
        railway_companies = railway_companies.where(status: params[:status].split(','))
      else
        railway_companies = railway_companies.where(status: 0)
      end

      render json: {
        railway_companies: railway_companies.map{|railway_company|
          railway_company.as_json(only: [:status, :company_type, :group_code, :code, :name, :name_kana, :name_full, :name_short, :url])
        },
        initials: railway_companies.sort_by(&:name_kana).group_by(&:head_kana).sort_by(&:first).to_h
      }
    end

    def lines
      if params[:prefecture_code].blank? && params[:railway_company_code].blank?
        return render json: {
          message: 'prefecture_code or railway_company_code is required.'
        }, status: 400
      end

      if params[:prefecture_code].present?
        lines = GeoMasterJp::Prefecture.find_by(code: params[:prefecture_code]).lines
      else
        lines = GeoMasterJp::RailwayCompany.find_by(code: params[:railway_company_code]).lines
      end

      if params[:status].present?
        lines = lines.where(status: params[:status].split(','))
      else
        lines = lines.where(status: 0)
      end

      render json: {
        lines: lines.map{|line|
          line.as_json(only: [:status, :code, :name, :name_kana, :name_full, :longitude, :latitude, :sort_order])
        },
        initials: lines.sort_by(&:name_kana).group_by(&:head_kana).sort_by(&:first).to_h
      }
    end

    def stations
      if params[:line_code].blank?
        return render json: {
          message: 'line_code is required.'
        }, status: 400
      end

      stations = GeoMasterJp::Line.find_by(code: params[:line_code]).stations.includes(:station_connections)

      if params[:prefecture_code].present?
        stations = stations.where(geo_master_jp_prefecture_code: params[:prefecture_code])
      end

      if params[:status].present?
        stations = stations.where(status: params[:status].split(','))
      else
        stations = stations.where(status: 0)
      end

      render json: {
        stations: stations.map{|station|
          station.as_json(
            only: [:status, :code, :group_code, :name, :zip_code, :address, :longitude, :latitude, :open_date, :close_date, :sort_order],
            methods: :neighbor_station_codes,
          )
        }
      }
    end

    def same_stations
      if params[:station_code].blank?
        return render json: {
          message: 'station_code is required.'
        }, status: 400
      end

      stations = GeoMasterJp::Station.find_by(code: params[:station_code]).same_stations

      if params[:status].present?
        stations = stations.where(status: params[:status].to_i)
      end

      render json: {
        stations: stations.map{|station|
          line.as_json(only: [:status, :code, :group_code, :name, :zip_code, :address, :longitude, :latitude, :open_date, :close_date, :sort_order])
        }
      }
    end
  end
end
