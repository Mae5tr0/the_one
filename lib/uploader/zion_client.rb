require 'net/http'
require 'zip'
require 'open-uri'
require 'tempfile'

module Uploader
  # Zion client, provide interface for download raw data and upload routes
  #
  # @attr passphrase [String] secret passphrase for accessing to Zion
  #
  # @example
  #  client = Uploader::ZionClient.new('secret_passphrase')
  #
  class ZionClient
    BASE_URL = 'http://challenge.distribusion.com/the_one/routes'.freeze

    attr_accessor :passphrase

    def initialize(passphrase)
      @passphrase = passphrase
    end

    # Download and extract specified source
    #
    # @param source [String] one of [sentinels, sniffers, loopholes]
    # @return [Array<OpenStruct>]
    #   @option name [String] filename from zip archive
    #   @option content [String] raw content
    def download(source)
      files = []
      temp_file = Tempfile.new('archive')
      begin
        temp_file.write(open("#{BASE_URL}?passphrase=#{@passphrase}&source=#{source}").read)
        temp_file.rewind
        Zip::File.open(temp_file) do |zip_file|
          zip_file.each do |entry|
            next if entry.name =~ /__MACOSX/ or entry.name =~ /\.DS_Store/ or !entry.file?
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
