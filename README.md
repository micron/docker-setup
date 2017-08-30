# Kreativrudel Docker Compose Launcher

This small script initializes an docker-compose environment.
 
## Installation

Just run the ``init.sh`` script from this repo in your project root directory:
 
``bash <(curl -s https://raw.githubusercontent.com/micron/docker-setup/master/init.sh)``

If you're lazy like me I suggest that you create an alias for this command:

``alias docker-init="bash <(curl -s https://raw.githubusercontent.com/micron/docker-setup/master/init.sh)"``

When all is done you'll have the following files and folders in your project directory:

    ├── docker                          # holds the configurations files
    │   ├── run-mysql-dump.sh           # mysql dump script
    │   ├── dumps                       # imports everything with an .sql or .sql.gz suffix into the database on initial startup
    │   ├── lib                         # mysql /var/lib/mysql directory for data persistance
    │   │   └── mysql
    │   ├── nginx                       # nginx webserver configuration
    │   │   └── default.conf
    │   └── supervisord                 # can be ignored
    │       ├── start-socat.sh
    │       └── supervisord-socat.conf
    └── docker-compose.yml              # actual docker compose file

## In action

To bootup the containers just run ``docker-compose up``. If you want to daemonize just append the ``-d`` option. Depending on your database import file (if present) it could take a while until the mysql container will become available.

To restart the containers run ``docker-compose restart``. To shutdown all containers run ``docker-compose stop``.

### Accessing your application

The application listens on your localhost on port 8088. When everything worked you should see you application under ``http://localhost:8088``.

### Logging

To read the logs from an running container just type ``docker logs -f application_wordpress_1``.

#### Loggin in php the php container

To read the whole log stream from a php container you can do the following:

``docker logs -f application_php_1``

To display only errors in the stream:

``docker logs -f application_php_1 >/dev/null``

To display only the access log in the stream:

``docker logs -f application_php_1 2>/dev/null``

[Source](https://github.com/docker-library/php/issues/212#issuecomment-204817907)

### Debugging

Our php images come always bundled with xdebug. Unfortunately you need to make a modification in the nginx config under ``docker/nginx/default.conf``.
Alter the IP in the following line: ``fastcgi_param REMOTE_ADDR "192.168.63.26";``. After the modification you need to restart the container.

Since the port 9000 is already taken by the php-fpm service you have to listen on port 9001 for incoming xdebug connections.

### Testing

This docker-compose setup comes with an [selenium container](https://github.com/elgalu/docker-selenium). It listens on port 4444 on your local machine.
You can also connect to the container with a [vnc-viewer client](https://www.realvnc.com/download/viewer/)

## Database

### Create a snapshot

If you want to create a snapshot from the current ``application`` database cd into the docker directory and run ``./dump-mysql.sh``.
You'll be asked which container you want to run. **WARNING** The destination file in the dumps directory will be overriden without asking.
