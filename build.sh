#!/bin/bash -x

ver=${VERSION:="1.8.1"}
exp_name=prometheus

NAME=$(basename $(dirname $PWD/Dockerfile))
URL="https://github.com/prometheus/${exp_name}/releases/download/v${ver}/${exp_name}-${ver}.linux-armv7.tar.gz"

wget -N $URL
tar xzf ${exp_name}-${ver}.linux-armv7.tar.gz --strip-components 1 --wildcards "*/prom*" "*/console*"

docker build -t ${NAME}:${ver} -t ${NAME}:latest .

rm -rf prometheus promtool prometheus.yml console*
