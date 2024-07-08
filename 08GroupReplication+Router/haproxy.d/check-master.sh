#!/bin/bash

[ $(mysql -u root -h ${HAPROXY_SERVER_NAME} -sNe "select @@global.super_read_only") = 0 ]