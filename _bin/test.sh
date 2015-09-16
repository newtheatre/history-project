#!/bin/bash

bundle exec htmlproof _site --file-ignore /lib/
jsonlint -q _site/feeds/search.json
