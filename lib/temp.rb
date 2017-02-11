require_relative '../lib/uploder'
require 'httplog'

client = Uploader::Client.new('http://challenge.distribusion.com/the_one/routes{?passphrase,source}', 'Kans4s-i$-g01ng-by3-bye')

data = client.download('sentinels')
# data = client.download('sniffers')
# data = client.download('loopholes')

puts data
client.upload(data)