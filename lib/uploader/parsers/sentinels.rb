module Uploader
  module Parsers
    class Sentinels < BaseParser
      def parse
        routes = {}
        CSV.new(@raw_data.gsub('"', '')).drop(1).map do |row|
          routes[row[0]] = routes.fetch(row[0], []).push(
              {
                  node: row[1].strip,
                  index: row[2].to_i,
                  time: Time.parse(row[3]).utc.strftime('%FT%T')
              }
          )
        end
        routes.values.select { |route| route.length > 1 }.map do |route|
          sorted_route = route.sort_by { |hash| hash[:index] }
          OpenStruct.new({
                             source: 'sentinels',
                             start_node: sorted_route.first[:node],
                             end_node: sorted_route.last[:node],
                             start_time: sorted_route.first[:time],
                             end_time: sorted_route.last[:time]
                         })
        end
      end
    end
  end
end