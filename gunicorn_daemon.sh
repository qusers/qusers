#!/bin/bash

NAME="qdyn.no-ip.org" # Name of the application
PROJDIR=/srv/www/qwebsite/ # Plain html wsgi project directory
SOCKFILE=/srv/www/qwebsite.sock # we will communicte using this unix socket
HTML_WSGI_MODULE=wsgiapp.py # WSGI module name
USER=qadmin   # the user to run as
GROUP=qadmin  # the group to run as
NUM_WORKERS=3 # how many worker processes should Gunicorn spawn
echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $PROJDIR
source bin/activate
export PYTHONPATH=$PROJDIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Gunicorn APP
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
#exec  gunicorn ${DJANGO_WSGI_MODULE}:application \
echo  "gunicorn ${HTML_WSGI_MODULE}:application \      
--name $NAME \
--workers $NUM_WORKERS \
--user=$USER --group=$GROUP \
--log-level=debug \
--bind=unix:$SOCKFILE \
--error-logfile /srv/www/qwebsite/logs/gunicorn.errors \
--log-file /srv/www/qwebsite/logs/gunicorn.log"
