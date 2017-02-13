module Uploader
  # Base class for all parsers
  #
  # Every parser should implement parse method
  # Parse method should return array contained Route models
  #
  class BaseParser
    attr_accessor :files

    def initialize(files)
      @files = files
    end

    def parse
      raise NotImplementedError
    end
  end
end
