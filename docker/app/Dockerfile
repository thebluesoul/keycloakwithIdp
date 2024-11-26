FROM node:18

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json 복사
COPY ./src/package*.json ./

# 의존성 설치
RUN npm install && npm install express --save

# 앱 소스 복사
# COPY ./src /usr/src/app/

ENV NODE_PATH=/app/node_modules

# 포트 노출
# EXPOSE 3000

# 앱 실행
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
