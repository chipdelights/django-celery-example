#!/bin/bash

/usr/local/bin/uwsgi --ini /etc/uwsgi/uwsgi.ini
/usr/sbin/nginx -g "daemon off;"
