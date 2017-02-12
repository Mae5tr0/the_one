require_relative 'uploader/version'
require_relative 'uploader/cli'
require_relative 'uploader/route'
require_relative 'uploader/zion_client'

# Parsers
require_relative 'uploader/parsers/base_parser'
require_relative 'uploader/parsers/loopholes_parser'
require_relative 'uploader/parsers/sentinels_parser'
require_relative 'uploader/parsers/sniffers_parser'

module Uploader
end

