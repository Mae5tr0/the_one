require 'csv'

module Uploader
  class SniffersParser < BaseParser
    def parse
      node_times = extract_data('node_times')
      raw_sequences = extract_data('sequences')

      sequences = merge_sequences_node_times(raw_sequences, node_times)
      routes = extract_data('routes')

      routes.map do |route|
        route_id = route[:route_id]
        route_sequence = sequences.select { |sequence| sequence[:route_id] == route_id }
        next if route_sequence.empty?

        start_node = route_sequence.first
        end_node = route_sequence.last
        period = route_sequence.reduce(0) { |a, e| a + e[:duration_in_milliseconds].to_i / 1000 }
        start_time = Time.strptime("#{route[:time]} #{route[:time_zone]}", '%FT%T %Z')

        Route.new(
          'sniffers',
          start_node[:start_node],
          end_node[:end_node],
          start_time.utc.strftime('%FT%T'),
          (start_time + period).utc.strftime('%FT%T')
        )
      end.reject(&:nil?)
    end

    private

    def merge_sequences_node_times(sequences, node_times)
      node_time_map = {}
      node_times.each do |node_time|
        node_time_id = node_time.delete(:node_time_id)
        node_time_map[node_time_id] = node_time
      end

      sequences.map do |sequence|
        node_time = node_time_map[sequence[:node_time_id]]
        next if node_time.nil?

        sequence.merge(node_time)
      end.reject(&:nil?)
    end

    def extract_data(key)
      result = { :"#{key}" => [] }
      file = @files.find { |parsed_file| parsed_file.name == "#{key}.csv" }
      return result if file.nil?

      CSV.new(file.content.delete('"'), col_sep: ', ', headers: true, header_converters: :symbol).map do |row|
        entry = {}
        row.each do |k, v|
          entry[k] = v
        end
        entry
      end
    end
  end
end
