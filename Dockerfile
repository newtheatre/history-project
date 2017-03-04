FROM quay.io/travisci/travis-ruby

EXPOSE 8000

USER travis
WORKDIR /home/travis
SHELL ["/bin/bash", "-lc"]

#### The script below is effectively the same as travis.yml
#### But with some changes to account for the fact that each RUN
#### occurs in a new session

RUN rvm use 2.2.0 --install --binary --fuzzy --default
RUN nvm install 6.10.0
RUN nvm alias default 6.10.0

# Move into a temp directory, we will then copy what we need on top of the git repo
RUN mkdir "/home/travis/to_copy"
WORKDIR "/home/travis/to_copy"

# Download htmltest
RUN mkdir "_bin"
RUN curl https://f000.backblazeb2.com/file/wjdp-lib/htmltest > _bin/htmltest
RUN chmod +x _bin/htmltest

# Make a directory for the site
RUN mkdir -p "/home/travis/newtheatre/history-project"
WORKDIR "/home/travis/newtheatre/history-project"

# Some optional environment variables 
ENV SMUGMUG_CACHE_MAINTAIN=TRUE
# ENV SMUGMUG_API_KEY=

# This enables verbose logging while the site is rendered
ENV JEKYLL_LOG_LEVEL=debug

RUN sudo mkdir /data
RUN sudo chown travis:travis /data

# The following is run each time the container is "run"
CMD echo "No command provided, you should be using run_dev.sh or run_dev.bat"