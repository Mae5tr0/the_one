module Uploader
  # Route model
  #
  # @attr source [String]
  # @attr start_node [String]
  # @attr end_node [String]
  # @attr start_time [String] format: ISO 8601 UTC time
  # @attr start_time [String] format: ISO 8601 UTC time
  #
  Route = Struct.new(:source, :start_node, :end_node, :start_time, :end_time)
end
