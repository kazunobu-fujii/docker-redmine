docker-redmine
==============

## Usage

```
docker run --name mysql -d -e 'DB_USER=dbuser' -e 'DB_PASS=dbpass' -e 'DB_NAME=dbname' sameersbn/mysql:latest
docker run --name redmine -d --link mysql:mysql -p 8080:8080  miraitechno/redmine
```


