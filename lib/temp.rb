require_relative '../lib/uploder'
require 'httplog'

SOURCE_PARSER_MAP = {
  # loopholes: Uploader::Loopholes,
  # sniffers: Uploader::Sniffers,
  sentinels: Uploader::SentinelsParser
}.freeze

client = Uploader::ZionClient.new('Kans4s-i$-g01ng-by3-bye')

parser = Uploader::SentinelsParser.new(client.download('sentinels'))
routes = parser.parse
# data = client.download('sniffers')
# data = client.download('loopholes')


puts routes