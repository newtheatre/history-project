#!/bin/bash

bundle exec htmlproof _site --file_ignore "_site/lib/fancybox/demo/index.html"
jsonlint -q _site/feeds/search.json
