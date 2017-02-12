require 'csv'

class SniffersParser < BaseParser
  def parse
    # CSV.new(@raw_data.gsub('"', '')).drop(1).map do |row|
    #   OpenStruct.new({
    #                      source: 'sniffers',
    #                      start_node: row[1].strip,
    #                      end_node: row[2].strip,
    #                      start_time: Time.parse('2030-12-31T22:00:02+09:00').utc.strftime('%FT%T'),
    #                      end_time: Time.parse('2030-12-31T22:00:02+09:00').utc.strftime('%FT%T')
    #                  })
    # end
  end
end