require 'csv'

module Uploader
  class SentinelsParser < BaseParser
    def parse
      routes = []
      files.each do |file|
        routes << parse_routes(file.content)
      end
      routes.flatten
    end

    private

    def parse_routes(raw_content)
      routes = extract_data(raw_content)

      routes.values.select { |route| route.length > 1 }.map do |route|
        sorted_route = route.sort_by { |hash| hash[:index] }
        Route.new(
          'sentinels',
          sorted_route.first[:node],
          sorted_route.last[:node],
          sorted_route.first[:time],
          sorted_route.last[:time]
        )
      end
    end

    def extract_data(raw_content)
      routes = {}
      CSV.new(
        raw_content.delete('"'),
        col_sep: ', ',
        headers: true,
        return_headers: false,
        header_converters: :symbol
      ).map do |row|
        routes[row[:route_id]] = routes.fetch(row[:route_id], []).push(
          node: row[:node],
          index: row[:index].to_i,
          time: Time.parse(row[:time]).utc.strftime('%FT%T')
        )
      end
      routes
    end
  end
end
