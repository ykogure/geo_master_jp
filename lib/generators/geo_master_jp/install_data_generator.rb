require 'zip'
require 'open-uri'
require 'yaml'
require "nkf"

module GeoMasterJp
  module Generators
    class InstallDataGenerator < Rails::Generators::Base
      include ::Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      desc "Download and insert geo data to your application databases."

      def set_prefectures
        if GeoMasterJp::Prefecture.count > 0
          puts "Prefecture is already exists and skip."
          return
        end
        YAML.load_file("#{__dir__}/data/prefectures.yml").each do |prefecture|
          GeoMasterJp::Prefecture.create(prefecture)
        end

        puts "Set Prefecture is complete."
      end

      def set_cities_and_towns
        GeoMasterJp::Prefecture.all.each_with_index do |prefecture, idx|
          print "Setting City and Town ...#{idx+1}/#{47}\r"

          if prefecture.cities.present? && prefecture.towns.present?
            next
          end

          location_data = download_location_data_and_convert_to_csv(prefecture)
          zip_code_data = download_zip_code_data_and_convert_to_csv(prefecture).group_by{|row| row[7]}

          towns = {}
          location_data.group_by{|row| row[2]}.each do |_, data|
            city = prefecture.cities.build

            city.code = format('%05d', data[0][2].to_i)
            city.name = data[0][3]

            zip_code_city = zip_code_data[city.name].try(:[], 0)

            if zip_code_city
              city.name_kana = NKF.nkf("-Xw", zip_code_city[4])
              city.name_alphabet = Romaji.kana2romaji(zip_code_city[4])
            end

            city.save

            towns[city.code] = []
            data.each do |town_row|
              town = city.towns.build(geo_master_jp_prefecture_id: prefecture.id)
              town.city = city
              town.code = format('%012d', town_row[4].to_i)
              town.name = town_row[5]
              town.latitude = town_row[6].to_f
              town.longitude = town_row[7].to_f

              towns[city.code] << town
            end
          end

          towns.each do |_city_code, ts|
            GeoMasterJp::Town.import ts
          end
        end
        print "\n"
      end

      private

        def download_location_data_and_convert_to_csv(prefecture)
          version = "11.0b"
          url = "http://nlftp.mlit.go.jp/isj/dls/data/#{version}/#{prefecture.code}000-#{version}.zip"

          csv_data = nil
          open(URI.escape(url)) do |file|
            Zip::File.open_buffer(file.read) do |zip|
              entry = zip.glob("#{prefecture.code}000-#{version}/*.csv").first
              csv_data = entry.get_input_stream.read
            end
          end

          csv_data = csv_data.encode("UTF-8", "CP932").split(/\r\n/).map{|row| row.split(',')}.map{|row| row.map{|val| val[1..-2]}}
          csv_data[1..-1]
        end

        def download_zip_code_data_and_convert_to_csv(prefecture)
          if prefecture.id == 26
            name = 'kyouto'
          else
            name = prefecture.name_alphabet[0..5]
          end

          url = "https://www.post.japanpost.jp/zipcode/dl/kogaki/zip/#{prefecture.code}#{name}.zip"

          csv_data = nil
          open(URI.escape(url)) do |file|
            Zip::File.open_buffer(file.read) do |zip|
              csv_data = zip.first.get_input_stream.read
            end
          end

          csv_data = csv_data.encode("UTF-8", "CP932").split(/\r\n/).map{|row| row.split(',')}.map{|row| row.map{|val| val[1..-2]}}
          csv_data
        end

    end
  end
end
