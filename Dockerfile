FROM quay.io/travisci/travis-ruby

###
# This docker file provides a consistant environment for running the 
# project locally. See the "Docker" section of README.md for more information
###

EXPOSE 8000

USER travis
WORKDIR /home/travis
SHELL ["/bin/bash", "-lc"]

RUN rvm use 2.2.0 --install --binary --fuzzy --default
RUN nvm install 6.10.0
RUN nvm alias default 6.10.0

# Make a directory for the site
RUN mkdir -p "/home/travis/newtheatre/history-project"
WORKDIR "/home/travis/newtheatre/history-project"

# Some optional environment variables 
ENV SMUGMUG_CACHE_MAINTAIN=TRUE
# ENV SMUGMUG_API_KEY=

# This enables verbose logging while the site is rendered
# ENV JEKYLL_LOG_LEVEL=debug

# Make a directory to work in
RUN sudo mkdir /data
RUN sudo chown travis:travis /data

# The following is run each time the container is "run"
CMD echo "No command provided, you should be using run_dev.sh"