#!/bin/sh

##
# This script manages using a docker container for local development
# See the "Docker" section of README.md for more information
##

noParams=false
stopAtEnd=false
if [ $# -eq 0 ]
  then
  echo "No parameters provided, running '(start) install build test serve'"
  noParams=true
fi

# Functions to start and stop the docker container
start () { 
    echo "----- Stopping Container (if exists)"
    stop
    echo "----- Building Container"
    docker build -t history-project .
    echo "----- Starting Container"
    docker run -itd \
        --name="history-project" \
        -p=8000:8000 \
        -v "$(pwd)":/home/travis/newtheatre/history-project \
        history-project \
        tail -f /dev/null
}

stop () {
    echo "----- Stopping history-project container"
    docker stop -t=0 history-project
    echo "----- Destroying history-project container"
    docker rm history-project
}


# Script fragments to be assembled and sent to the container
script="echo '----- RSyncing repo into linux filesystem'     &&\
        rsync -Pa --delete                                  \
            --exclude '.bundle'                             \
            --exclude 'node_modules'                        \
            --exclude 'lib'                                 \
            --exclude 'vendor/bundle'                       \
            --exclude '_smugmug_cache'                      \
            --exclude 'tmp'                                 \
            --exclude '.sass-cache'                         \
            --exclude '_site'                         \
            '/home/travis/newtheatre/history-project/' '/data/'    &&\
        cd /data"

installdep="echo '----- Install htmltest' &&\
    	curl https://htmltest.wjdp.uk > _bin/htmltest &&\
        chmod +x _bin/htmltest &&\
        echo '----- Bundle Install' &&\
        bundle install --jobs=3 --retry=3 --deployment
        echo '----- NPM Install' &&\
        npm install
    	echo '----- Bower Install' &&\
    	bower install --allow-root"
    	
build_site="echo '----- Building Site' &&\
    	gulp build"

test_site="echo '----- Testing Site' &&\
    	gulp test"

serve_site="echo '----- Serving Site' &&\
    	gulp dockerserver"


# Assemble the fragments, based on input parameters
do_script=false
while test $# -gt 0
do
    case "$1" in
        stop) 
            stopAtEnd=true
        ;;
        start) 
			start
        ;;
        install) 
			script="$script && $installdep"
            do_script=true
        ;;
        build) 
			script="$script && $build_site"
            do_script=true
        ;;
        test) 
			script="$script && $test_site"
            do_script=true
        ;;
        serve) 
			script="$script && $serve_site"
            do_script=true
        ;;
        *) echo "Unknown argument $1"
			exit 1
        ;;
    esac
    shift
done

# If there weren't any input parameters, then do the default
if ${noParams:-false} ; then
    doStart=false
    docker exec history-project true 2>/dev/null || doStart=true
    if ${doStart:-false} ; then
        echo "----- Container not running, starting up"
        start
    else
        echo "----- Container already running, continuing"
    fi
    script="$script && $installdep"
    script="$script && $build_site"
    script="$script && $test_site"
    script="$script && $serve_site"
    do_script=true
fi


# Run the script
if ${do_script:-false} ; then
    docker exec -it history-project /bin/bash -lc "$script"
fi

if ${stopAtEnd:-false} ; then
    stop
fi
