require 'zip'
require 'open-uri'
require 'yaml'

module GeoMasterJp
  module Generators
    class InstallRailwayDataGenerator < Rails::Generators::Base
      RAILWAY_COMPANY_VERSION    = '20180424'
      LINE_VERSION               = '20190405'
      STATION_VERSION            = '20190405'
      STATION_CONNECTION_VERSION = '20190405'

      source_root File.expand_path('templates', __dir__)

      desc "Download and insert railway data to your application databases."

      def set_railway_companies
        if GeoMasterJp::Version.last_version(GeoMasterJp::RailwayCompany).present? && GeoMasterJp::Version.last_version(GeoMasterJp::RailwayCompany) >= Date.parse(RAILWAY_COMPANY_VERSION)
          puts "RailwayCompany is already latest version and skip."
          return
        end

        csv_data = get_railway_data("company#{RAILWAY_COMPANY_VERSION}.csv")
        csv_data.each do |row|
          railway_company = GeoMasterJp::RailwayCompany.find_by(code: format('%03d', row[0].to_i)) || GeoMasterJp::RailwayCompany.new
          railway_company = set_railway_company(railway_company, row)
          railway_company.save
        end

        GeoMasterJp::Version.create!(model_name_string: GeoMasterJp::RailwayCompany.to_s, version: Date.parse(RAILWAY_COMPANY_VERSION))

        print "\n"
        puts "Set RailwayCompany is complete."
      end

      def set_lines
        if GeoMasterJp::Version.last_version(GeoMasterJp::Line).present? && GeoMasterJp::Version.last_version(GeoMasterJp::Line) >= Date.parse(LINE_VERSION)
          puts "Line is already latest version and skip."
          return
        end

        csv_data = get_railway_data("line#{LINE_VERSION}free.csv")
        csv_data_each_railway_company_code = csv_data.group_by{|row| format('%03d', row[1].to_i)}
        csv_data_each_railway_company_code.each_with_index do |(railway_company_code, rows), idx|
          print "Setting Line ...#{idx+1}/#{csv_data_each_railway_company_code.count}\r"

          railway_company = GeoMasterJp::RailwayCompany.find_by(code: railway_company_code)
          rows.each do |row|
            line = GeoMasterJp::Line.find_by(code: format('%05d', row[0].to_i)) || railway_company.lines.build
            line = set_line(line, row)
            line.save
          end
        end

        GeoMasterJp::Version.create!(model_name_string: GeoMasterJp::Line.to_s, version: Date.parse(LINE_VERSION))

        print "\n"
        puts "Set Line is complete."
      end

      def set_stations
        if GeoMasterJp::Version.last_version(GeoMasterJp::Station).present? && GeoMasterJp::Version.last_version(GeoMasterJp::Station) >= Date.parse(STATION_VERSION)
          puts "Station is already latest version and skip."
          return
        end

        csv_data = get_railway_data("station#{STATION_VERSION}free.csv")
        csv_data_each_line_code = csv_data.group_by{|row| format('%05d', row[5].to_i)}
        csv_data_each_line_code.each_with_index do |(line_code, rows), idx|
          print "Setting Station ...#{idx+1}/#{csv_data_each_line_code.count}\r"

          line = GeoMasterJp::Line.find_by(code: line_code)
          rows.each do |row|
            station = GeoMasterJp::Station.find_by(code: format('%07d', row[0].to_i)) || line.stations.build
            station = set_station(station, row)
            station.save
          end
        end

        GeoMasterJp::Version.create!(model_name_string: GeoMasterJp::Station.to_s, version: Date.parse(STATION_VERSION))

        print "\n"
        puts "Set Station is complete."
      end

      def set_station_connections
        if GeoMasterJp::Version.last_version(GeoMasterJp::StationConnection).present? && GeoMasterJp::Version.last_version(GeoMasterJp::StationConnection) >= Date.parse(STATION_CONNECTION_VERSION)
          puts "StationConnection is already latest version and skip."
          return
        end

        csv_data = get_railway_data("join#{STATION_CONNECTION_VERSION}.csv")

        csv_data_each_line_code = csv_data.group_by{|row| format('%05d', row[0].to_i)}
        csv_data_each_line_code.each_with_index do |(line_code, rows), idx|
          print "Setting StationConnection ...#{idx+1}/#{csv_data_each_line_code.count}\r"

          line = GeoMasterJp::Line.find_by(code: line_code)
          rows.each do |row|
            station_1 = GeoMasterJp::Station.find_by(code: format('%07d', row[1].to_i))
            station_2 = GeoMasterJp::Station.find_by(code: format('%07d', row[2].to_i))

            next if station_1.blank? || station_2.blank?

            station_connection = GeoMasterJp::StationConnection.new
            station_connection.line = line
            station_connection.station_1 = station_1
            station_connection.station_2 = station_2

            station_connection.save
          end
        end

        GeoMasterJp::Version.create!(model_name_string: GeoMasterJp::StationConnection.to_s, version: Date.parse(STATION_CONNECTION_VERSION))

        print "\n"
        puts "Set StationConnection is complete."
      end

      private

        def set_railway_company(railway_company, row)
          company_types = {
            '0' => 'その他',
            '1' => 'JR',
            '2' => '大手私鉄',
            '3' => '準大手私鉄'
          }

          railway_company.status       = row[8].to_i
          railway_company.company_type = company_types[row[7]]
          railway_company.code         = format('%03d', row[0].to_i)
          railway_company.group_code   = row[1]
          railway_company.name         = row[2]
          railway_company.name_kana    = row[3]
          railway_company.name_full    = row[4]
          railway_company.name_short   = row[5]
          railway_company.url          = row[6]
          railway_company.sort_order   = row[9].to_i

          railway_company
        end

        def set_line(line, row)
          line.status     = row[11].to_i
          line.code       = format('%05d', row[0].to_i)
          line.name       = row[2]
          line.name_kana  = row[3]
          line.name_full  = row[4]
          line.longitude  = row[8]
          line.latitude   = row[9]
          line.sort_order = row[12].to_i

          line
        end

        def set_station(station, row)
          station.geo_master_jp_prefecture_id = row[6].to_i

          station.status     = row[13].to_i
          station.code       = format('%07d', row[0].to_i)
          station.group_code = format('%07d', row[1].to_i)
          station.name       = row[2]
          station.zip_code   = row[7].gsub('-', '')
          station.address    = row[8].gsub('-', '')
          station.longitude  = row[9]
          station.latitude   = row[10]
          station.open_date  = Date.parse(row[11]) if row[11].present?
          station.close_date = Date.parse(row[12]) if row[12].present?
          station.sort_order = row[14].to_i

          station
        end

        def get_railway_companies_csv_data
          file_path = "#{__dir__}/data/company20180424.csv.zip"
          csv_data = nil
          open(file_path) do |file|
            Zip::File.open_buffer(file.read) do |zip|
              entry = zip.glob('company20180424.csv').first
              csv_data = entry.get_input_stream.read
            end
          end
          csv_data.force_encoding('UTF-8').split(/\n/).map{|row| row.split(',')}[1..-1]
        end

        def get_railway_data(file_name)
          file_path = "#{__dir__}/data/#{file_name}.zip"
          csv_data = nil
          open(file_path) do |file|
            Zip::File.open_buffer(file.read) do |zip|
              entry = zip.glob(file_name).first
              csv_data = entry.get_input_stream.read
            end
          end
          csv_data.force_encoding('UTF-8').split(/\n/).map{|row| row.split(',')}[1..-1]
        end

    end
  end
end
