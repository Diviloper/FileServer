# File Server

#### Requirements
* Docker

#### Config
To set the shared folder and the listened port, change the [docker compose file](./docker-compose.yml).

#### Start
To run de server, just build and start the docker container:
``` 
docker-compose build
docker-compose run -d
```