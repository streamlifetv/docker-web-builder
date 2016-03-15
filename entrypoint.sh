#!/bin/bash

set -eo pipefail

if [ ! -z ${GITHUB_ACCESS_TOKEN} ]; then
    # config composer to use github-token not to run into GitHub API rate limit
    composer config -g github-oauth.github.com ${GITHUB_ACCESS_TOKEN}
fi

exec "$@"