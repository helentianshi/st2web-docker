#!/bin/bash

DIR="/opt/st2web"

# Lets check to see if this directory is empty
if [ "$(ls -A $DIR)" ]; then
     
	# Directory isn't empty, we assume everything is installed
	echo "$DIR is not Empty"
else
    
    # Directory is empty
    echo "$DIR is Empty"

    # Change to st2web directory
	cd /opt/st2web

	# Clone repo
	git clone https://github.com/StackStorm/st2web.git .

	# Install 
	npm install
	gulp production

fi

# Copy over config.js
cp /data/config.js /opt/st2web/config.js

# Set URLs
sed -i -e 's~API_URL_REPLACE~'"$API_URL"'~g' /opt/st2web/config.js
sed -i -e 's~AUTH_URL_REPLACE~'"$AUTH_URL"'~g' /opt/st2web/config.js

# Change to st2web directory
cd /opt/st2web

# Run gulp to serve website
gulp serve