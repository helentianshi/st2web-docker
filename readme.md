## Overview

This builds a st2web container from Stackstorm's git repo.  The initial restart up takes a bit because it clones the repo.

## Basic Usage

Follow the directions here to build your images for [Stackstorm](https://github.com/StackStorm/st2-dockerfiles)

Before running docker-compose up -d

Modify the docker compose file and make the API\AUTH ports available externally.  You have to do this because your web browser is actually connecting to both the API and AUTH servers directly.

```
api:
  image: stackstorm/st2api
  links:
    - mongo
    - rabbitmq
  ports:
    - "9101:9101"
  volumes_from:
    - data

auth:
  image: stackstorm/st2auth
  links:
    - api
    - mongo
  ports:
    - "9100:9100"
  volumes_from:
    - data
```

Added the required entry for CORS in data/st2.conf.  For this one, I had to modify the st2.conf in the volume and restart the containers to make it work. 

```
[api]
host = 0.0.0.0
port = 9101
mask_secrets = True
logging = /etc/st2/logging.api.conf

# allow_origin is required for handling CORS in st2 web UI.
# allow_origin = http://myhost1.example.com:3000,http://myhost2.example.com:3000
allow_origin http://<domain_for_st2web>:<port>
```

Run docker-compose up -d

Test to make sure you containers came up correctly
```
docker-compose run --rm client st2 action list
```


Now run the st2web container, passing in the locations for the API and Auth

```
docker run -it -d -p 3000:3000 \
  -e API_URL='http://<ip_to_docker_match>:9101' \
  -e AUTH_URL='http://<ip_to_docker_match>:9100' \
  --name st2web jthunt/st2web
```

use docker log to follow the install process
```
docker logs -f st2web
```

If you ran all this without changing the username/password in the docker compose build for Stackstorm, the default is st2admin/Ch@ngeMe

