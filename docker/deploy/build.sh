#!/usr/bin/env bash
MODULE=$(dirname $(readlink -f $0))
cd $MODULE

cat <<EOF > env
export GIT_HOST=${GIT_HOST}
export TOKEN=${TOKEN}
EOF

docker build -t dire/deploy:latest $MODULE

rm env

cd -
