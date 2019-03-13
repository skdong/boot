#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
source $MODULE/bootrc

docker run --rm -t -i -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image dire/deploy \
  --docker-privileged=false \
  --docker-pull-policy="if-not-present" \
  --docker-extra-hosts "gitlab$DOMAIN:$GIT_HOST,$HOST_NAME:$HOST" \
  --url http://$GIT_HOST/ \
  --registration-token "$GIT_RUNNER_TOKEN" \
  --description "dire" \
  --tag-list "dire" \
  --run-untagged \
  --locked="false"