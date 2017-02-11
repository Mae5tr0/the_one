require 'json'

module Uploader
  module Parsers
    class Loopholes < BaseParser
      def parse
        puts 'parse loopholes'
        JSON.parse(raw_data, symbolize_names: true).fetch(:node_pairs, [])
            .map do |node_pair|
          OpenStruct.new({
                             source: 'loopholes',
                             start_node: node_pair[:start_node],
                             end_node: node_pair[:end_node],
                             start_time: Time.parse('2030-12-31T22:00:02+09:00').utc.strftime('%FT%T'),
                             end_time: Time.parse('2030-12-31T22:00:02+09:00').utc.strftime('%FT%T')
                         })
        end
      end
    end
  end
end

