require 'json'

module Uploader
  class LoopholesParser < BaseParser
    #TODO optimize through merge
    def parse
      node_pairs = extract_data('node_pairs')
      routes = extract_data('routes')

      routes.fetch(:routes, []).map do |route|
        node = node_pairs.fetch(:node_pairs, []).find { |node_pair| node_pair[:id] == route[:node_pair_id] }
        next if node.nil?
        Route.new(
            'loopholes',
            node[:start_node],
            node[:end_node],
            Time.parse(route[:start_time]).utc.strftime('%FT%T'),
            Time.parse(route[:end_time]).utc.strftime('%FT%T')
        )
      end.reject(&:nil?)
    end

    private

    def extract_data(key)
      file = @files.find { |file| file.name == "#{key}.json" }
      return { :"#{key}" => [] } if file.nil?
      JSON.parse(file.content, symbolize_names: true)
    end
  end
end