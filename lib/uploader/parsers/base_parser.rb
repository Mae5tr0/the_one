module Uploader
  #TODO documentation
  class BaseParser
    attr_accessor :files

    def initialize(files)
      @files = files
    end

    # Every parser should implement this method
    # @return Array<Route>
    def parse
      fail NotImplementedError
    end
  end
end
