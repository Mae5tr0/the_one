# The one - helper for Neo extracting from Matrix

## Description

App download zip files from specified source, parsed it and upload.
	
## Usage
	
	$ ruby bin/cli.rb upload -s=sentinels sniffers loopholes -p=super_secret_passphrase
		
Some notes: if key contained special bash symbols, they should be escaped:
		
	Kans4s-i$ -> Kans4s-i\$
		