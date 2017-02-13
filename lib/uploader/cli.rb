require 'thor'

module Uploader
  class CLI < Thor
    include Thor::Actions

    desc 'upload', 'Download, parse and upload sources'
    method_option :sources, aliases: '-s', desc: 'Alphanumeric code', type: :array, required: true
    method_option :passphrase, aliases: '-p', desc: 'Fasten your seat belt Dorothy', type: :string, required: true
    method_option :debug, aliases: '-d', desc: 'Print http requests', type: :boolean
    def upload
      require('httplog') unless options[:debug].nil?

      client = client(options[:passphrase])
      parser_map = {
        loopholes: Uploader::LoopholesParser,
        sniffers: Uploader::SniffersParser,
        sentinels: Uploader::SentinelsParser
      }

      routes = options[:sources].map do |source|
        puts "Download #{source}"

        data = client.download(source)
        parser_map[source.to_sym].new(data).parse
      end.flatten

      puts "Parsed #{routes.length} routes"
      puts 'Upload'
      client.upload(routes)
    end

    private

    def client(passphrase)
      Uploader::ZionClient.new(passphrase)
    end
  end
end
