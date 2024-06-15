require 'zip'
require 'open-uri'
require 'yaml'
require 'romaji'
require 'nkf'

module GeoMasterJp
  module Generators
    class InstallAreaDataGenerator < Rails::Generators::Base
      VERSION = '20201201'

      source_root File.expand_path('templates', __dir__)

      desc "Download and insert geo data to your application databases."

      def set_prefectures
        if GeoMasterJp::Prefecture.count > 0
          puts "Prefecture is already exists and skip."
          return
        end
        YAML.load_file("#{__dir__}/data/prefectures.yml").each do |prefecture|
          GeoMasterJp::Prefecture.create!(prefecture)
        end

        puts "Set Prefecture is complete."
      end

      def set_cities_and_towns
        if (GeoMasterJp::Version.last_version(GeoMasterJp::City).present? && GeoMasterJp::Version.last_version(GeoMasterJp::City) >= Date.parse(VERSION)) && (GeoMasterJp::Version.last_version(GeoMasterJp::Town).present? && GeoMasterJp::Version.last_version(GeoMasterJp::Town) >= Date.parse(VERSION))
          puts "City and Town is already latest version and skip."
          return
        end

        csv_data = download_city_and_town_data_and_convert_to_csv
        csv_data.group_by{|row| row[0][0..1]}.each_with_index do |(prefecture_code, rows), idx|
          print "Setting City and Town ...#{idx+1}/#{47}\r"

          prefecture = GeoMasterJp::Prefecture.find_by(code: prefecture_code)

          towns = {}
          rows.group_by{|row| row[0][0..4]}.each do |city_code, town_rows|
            next if town_rows[0][10].blank?

            if city = GeoMasterJp::City.find_by(code: city_code)
              if town_rows[0][26] == '2' # 変更
                city = set_city(city, town_rows[0])

                city.save!
              end
            else # 新規
              city = prefecture.cities.build(code: city_code)
              city = set_city(city, town_rows[0])

              city.save!
            end

            towns[city.code] = []
            town_rows.each do |town_row|
              town_code = town_row[0]

              if town = GeoMasterJp::Town.find_by(code: town_code)
                if town_row[26] == '2' # 変更
                  town = set_town(town, row)
                  town.city = city

                  town.save!
                elsif town_row[26] == '3' # 廃止
                  town.update!(deleted_at: Time.current)
                end
              else # 新規
                town = city.towns.build(geo_master_jp_prefecture_code: prefecture.code, code: town_code)
                town = set_town(town, town_row)
                town.city = city

                towns[city.code] << town
              end
            end
          end

          towns.each do |_city_code, ts|
            GeoMasterJp::Town.import ts
          end
        end

        GeoMasterJp::Version.create!(model_name_string: GeoMasterJp::City.to_s, version: Date.parse(VERSION))
        GeoMasterJp::Version.create!(model_name_string: GeoMasterJp::Town.to_s, version: Date.parse(VERSION))

        print "\n"
        puts "Set City and Town is complete."
      end

      private

        def download_city_and_town_data_and_convert_to_csv
          url = "https://www.japan-database.jp/database/#{VERSION[0..3]}/addressfc#{VERSION[0..5]}.zip"

          csv_data = nil
          OpenURI.open_uri(url) do |file|
            Zip::File.open_buffer(file.read) do |zip|
              entry = zip.glob("addressf#{VERSION[0..5]}.csv").first
              csv_data = entry.get_input_stream.read
            end
          end

          csv_data.encode("UTF-8", "CP932").split(/\r\n/).map{|row| row.split(',')}.map{|row| row.map{|val| val.gsub(/(^[[:space:]]+)|([[:space:]]+$)/, '')}}
        end

        def set_city(city, row)
          city.name = row[10]
          city.name_kana = row[6].present? ? NKF.nkf("-Xw", row[6]) : ''
          city.name_alphabet = Romaji.kana2romaji(city.name_kana)

          city
        end

        def set_town(town, row)
          town.name = row[11] + row[12]
          town.name_kana = (row[7] + row[8]).present? ? NKF.nkf("-Xw", row[7] + row[8]) : ''
          town.name_alphabet = Romaji.kana2romaji(town.name_kana)
          town.zip_code = row[2]
          town.deleted_at = Time.current if row[26] == '3' # 廃止

          town
        end

    end
  end
end
