#!/bin/bash -x

ver=${VERSION:="1.8.1"}
exp_name=prometheus

declare -a TAGS
TAGS=($ver)

NAME=$(basename $(dirname $PWD/Dockerfile))
URL="https://github.com/prometheus/${exp_name}/releases/download/v${ver}/${exp_name}-${ver}.linux-armv7.tar.gz"

wget -N $URL
tar xzf ${exp_name}-${ver}.linux-armv7.tar.gz --strip-components 1 --wildcards "*/prom*" "*/console*"

if [ $REPO_HOST ]
then
  NAME=${REPO_HOST}/${NAME}
fi

docker build -t ${NAME}:latest $@ .

if [ $REPO_HOST ]
then
  docker push ${NAME}:latest
fi

for i in ${TAGS[@]}
do
  docker tag ${NAME}:latest ${NAME}:$i

  if [ $REPO_HOST ]
  then
    docker push ${NAME}:$i
  fi
done

rm -rf prometheus promtool prometheus.yml console*
