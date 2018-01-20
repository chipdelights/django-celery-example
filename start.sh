#!/bin/bash

/usr/local/bin/python3 manage.py migrate --run-syncdb
/usr/local/bin/uwsgi --ini /etc/uwsgi/uwsgi.ini
/usr/sbin/nginx -g "daemon off;"
