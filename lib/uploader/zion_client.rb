require 'net/http'
require 'zip'
require 'open-uri'
require 'tempfile'

module Uploader
  class ZionClient
    BASE_URL = 'http://challenge.distribusion.com/the_one/routes'.freeze

    attr_accessor :passphrase

    #TODO documentation
    def initialize(passphrase)
      @passphrase = passphrase
    end

    # Download specified source
    #
    # @param source [String]
    # @return [Array<Hash>]
    def download(source)
      files = []
      temp_file = Tempfile.new('archive')
      begin
        temp_file.write(open("#{BASE_URL}?passphrase=#{@passphrase}&source=#{source}").read)
        temp_file.rewind
        Zip::File.open(temp_file) do |zip_file|
          zip_file.each do |entry|
            next if entry.name_is_directory?
            files << OpenStruct.new(
                name: filename(entry.name),
                content: entry.get_input_stream.read
            )
          end
        end
      ensure
        temp_file.close
        temp_file.unlink
      end
      files
    end

    # Upload routes
    #
    # @param routes [Array<Route>]
    def upload(routes)
      routes.each do |route|
        Net::HTTP.post_form(URI(BASE_URL), route.to_h.merge(passphrase: @passphrase))
      end
    end

    private

    def filename(raw_filename)
      raw_filename.split('/').last
    end
  end
end
