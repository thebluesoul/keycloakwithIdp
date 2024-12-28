#!/bin/bash

set -x

count=0  # 반복 횟수를 저장할 변수

echo "Waiting for MySQL to be ready..."
while ! echo > /dev/tcp/keycloak_mysql/3306; do
  count=$((count + 1))
  current_time=$(date +"%Y-%m-%d %H:%M:%S")  # 현재 시각 저장
  echo "Attempt #$count at $current_time: MySQL is not ready."
  sleep 3
done

echo "Starting Keycloak..."
/opt/keycloak/bin/kc.sh start --https-port=8443 --hostname-strict=false
# tail -f /dev/null