#!/usr/bin/env bash
set -e
set -x

docker run --name mysql \
  -v /usr/local/etc/my.cnf:/etc/mysql/conf.d/hthu.cnf:ro \
  -v ~/tmp/mysqldata:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=mzdzma23 \
  -p 3307:3306 \
  -d mysql:5.7

