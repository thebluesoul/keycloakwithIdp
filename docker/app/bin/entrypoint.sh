#!/bin/bash

set -x


# 앱 실행
echo "Starting application..."
cd /app/src
node app.js

# tail -f /dev/null