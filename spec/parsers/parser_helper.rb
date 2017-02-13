require 'zip'

require_relative '../../lib/uploader/parsers/base_parser'
require_relative '../../lib/uploader/route'

module ParserHelper
  def read_zip(filename)
    files = []
    Zip::File.open("spec/support/#{filename}.zip") do |zip_file|
      zip_file.each do |entry|
        next if entry.name =~ /__MACOSX/ || entry.name =~ /\.DS_Store/ || !entry.file?
        files << OpenStruct.new(
          name: entry.name.split('/').last,
          content: entry.get_input_stream.read
        )
      end
    end
    files
  end
end
