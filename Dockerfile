FROM "ubuntu:22.04"

###
# This docker file provides a consistant environment for running the 
# project locally. See the "Docker" section of README.md for more information
###
SHELL ["/bin/bash", "-c"]

EXPOSE 8000

RUN apt-get update

RUN apt-get install -y curl sudo gnupg2 build-essential rsync git

# Install Node
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.24.1

WORKDIR $NVM_DIR

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
# ENV SMUGMUG_API_KEY 

RUN apt-get install -y ruby-dev rubygems libffi-dev
RUN gem install bundler -v 1.17

RUN npm install -g gulp coffeescript bower
RUN npm link gulp-v3 --force
RUN npm rebuild node-sass 

# The following is run each time the container is "run"
CMD echo "No command provided, you should be using run_dev.sh"