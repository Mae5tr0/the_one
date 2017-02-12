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

    #TODO improve readability
    def parse_routes(raw_content)
      routes = {}
      CSV.new(raw_content.gsub('"', '')).drop(1).map do |row|
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
        Route.new(
            'sentinels',
            sorted_route.first[:node],
            sorted_route.last[:node],
            sorted_route.first[:time],
            sorted_route.last[:time]
        )
      end
    end
  end
end