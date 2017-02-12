require 'zip'
require 'ostruct'

require_relative '../../lib/uploader/parsers/base_parser'
require_relative '../../lib/uploader/route'

module ParserHelper
  def read_zip(filename)
    files = []
    Zip::File.open("spec/support/#{filename}.zip") do |zip_file|
      zip_file.each do |entry|
        next if entry.name_is_directory?
        files << OpenStruct.new(
            name: entry.name.split('/').last,
            content: entry.get_input_stream.read
        )
      end
    end
    files
  end
end