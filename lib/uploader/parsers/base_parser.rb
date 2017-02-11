module Uploader
  module Parsers
    class BaseParser
      attr_accessor :raw_data

      def initialize(data)
        @raw_data = data
      end

      # Every parser should implement this method
      # Method should return ValueObject array
      def parse
        fail NotImplementedError
      end
    end
  end
end
