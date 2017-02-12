require_relative '../lib/uploder'

#TODO improve message

puts ''
puts 'Uploader data'
puts ''

Uploader::CLI.start(ARGV)