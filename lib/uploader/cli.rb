require 'thor'

module Uploader
  class CLI < Thor
    include Thor::Actions

    desc 'upload', 'Download, parse and upload sources'
    method_option :sources, aliases: '-s', desc: 'Alphanumeric code', type: :array, required: true
    method_option :passphrase, aliases: '-p', desc: 'Fasten your seat belt Dorothy', type: :string, required: true
    def upload
      puts 'upload'
      puts options[:sources]
      puts options[:passphrase].class
    end

    private

    def client
      @client ||= Uploader::ZionClient.new('Kans4s-i$-g01ng-by3-bye')
    end
  end
end
