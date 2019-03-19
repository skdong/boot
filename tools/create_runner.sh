#!/usr/bin/env bash

MODULE=$(dirname $(readlink -f $0))
source $MODULE/bootrc

docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
  
docker exec -it gitlab-runner gitlab-ci-multi-runner register -n \
  --url http://$GIT_HOST/ \
  --registration-token "$GIT_RUNNER_TOKEN" \
  --tag-list=dire \
  --description "dire" \
  --docker-privileged=false \
  --docker-pull-policy="if-not-present" \
  --docker-image "dire/deploy" \
  --docker-volumes "/cache" \
  --docker-extra-hosts "gitlab$DOMAIN:$GIT_HOST" \
  --docker-extra-hosts "$HOST_NAME:$HOST" \
  --executor docker \
  --run-untagged \
  --locked="false"
