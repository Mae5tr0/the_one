# require 'savon'
# require 'logger'
# require 'active_support/configurable'
require 'net/http'
require 'addressable'
require 'zip'


# require 'tempfile'

module Uploader
  class Client
    SOURCE_PARSER_MAP = {
      loopholes: Parsers::Loopholes,
      sniffers: Parsers::Sniffers,
      sentinels: Parsers::Sentinels
    }.freeze

    attr_accessor :passphrase, :base_url

    def initialize(base_url, passphrase)
      @base_url = base_url
      @passphrase = passphrase
    end

    # Download specified source
    #
    # @param source [String]
    # @return [Array<ValueObject>]
    def download(source)
      template = Addressable::Template.new(@base_url)
      uri = template.expand({passphrase: @passphrase, source: source})
      puts uri.to_s
      response = Net::HTTP.get(URI(uri))
      unzip(response)
          .map { |raw_data| SOURCE_PARSER_MAP[source.to_sym].new(raw_data) }
          .map { |parser| parser.parse }
          .flatten
    end

    # Upload parsed source
    #
    # @param source [Array<ValueObject>]
    def upload(objects)
      objects.each do |object|
        uri = URI('http://challenge.distribusion.com/the_one/routes')
        Net::HTTP.post_form(uri, object.to_h.merge(passphrase: 'Kans4s-i$-g01ng-by3-bye'))
      end
    end

    private

    def unzip(zip_string)
      unzip_data = []
      Zip::InputStream.open(StringIO.new(zip_string)) do |io|
        while entry = io.get_next_entry
          next if io.eof?
          unzip_data << io.read
        end
      end
      unzip_data
    end
  end
end
