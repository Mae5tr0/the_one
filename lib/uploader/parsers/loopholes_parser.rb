require 'json'

module Uploader
  class LoopholesParser < BaseParser
    def parse
      grouped_routes = group_routes(
        merge_node_pairs_routes(
          extract_data('node_pairs'),
          extract_data('routes')
        )
      )

      grouped_routes.values.select { |routes| routes.length > 1 }.map do |routes|
        Route.new(
          'loopholes',
          routes.first[:start_node],
          routes.last[:end_node],
          Time.parse(routes.first[:start_time]).utc.strftime('%FT%T'),
          Time.parse(routes.last[:end_time]).utc.strftime('%FT%T')
        )
      end
    end

    private

    def extract_data(key)
      file = @files.find { |parsed_file| parsed_file.name == "#{key}.json" }
      return { :"#{key}" => [] } if file.nil?
      JSON.parse(file.content, symbolize_names: true)
    end

    def merge_node_pairs_routes(node_pairs, routes)
      node_pairs_map = {}
      node_pairs.fetch(:node_pairs, []).each do |node_pair|
        node_pair_id = node_pair.delete(:id)
        node_pairs_map[node_pair_id] = node_pair
      end
      routes.fetch(:routes, []).map do |route|
        node_pair = node_pairs_map[route[:node_pair_id]]
        next if node_pair.nil?
        route.merge(node_pair)
      end.reject(&:nil?)
    end

    def group_routes(routes)
      result = {}
      routes.each do |route|
        result[route[:route_id]] = result.fetch(route[:route_id], []).push(route)
      end
      result
    end
  end
end
