* 설치 순서
```bash
  # 컨테이너 상태 확인
  docker ps -a

  # 컨테이너 이미지 확인
  docker images -a

  # 실행중지된 컨테이너 삭제
  docker container prune -f

  # 도커이미지 삭제
  docker image prune -af

  # 도커이미지 생성(캐쉬무시)
  docker-compose build --no-cache

  # HTTPS를 위한 인증서 생성
  cd keycloakiwthIdp/docker
  ./gen-cert.sh

  # 도커컴포즈를 통해서 컨테이너 실행
  docker-compose up -d
```
* 실행로그
```
# docker-compose up -d
Creating network "docker_default" with the default driver
Creating volume "docker_mysql_data" with default driver
Pulling mysql (mysql:8.0)...
8.0: Pulling from library/mysql
2c0a233485c3: Pull complete
b746eccf8a0b: Pull complete
570d30cf82c5: Pull complete
c7d84c48f09d: Pull complete
e9ecf1ccdd2a: Pull complete
6331406986f7: Pull complete
f93598758d10: Pull complete
6c136cb242f2: Pull complete
d255d476cd34: Pull complete
dbfe60d9fe24: Pull complete
9cb9659be67b: Pull complete
Digest: sha256:d58ac93387f644e4e040c636b8f50494e78e5afc27ca0a87348b2f577da2b7ff
Status: Downloaded newer image for mysql:8.0
Pulling keycloak (quay.io/keycloak/keycloak:22.0.5)...
22.0.5: Pulling from keycloak/keycloak
baff9e5cc126: Pull complete
d4ab5454dd61: Pull complete
4991c9a01de1: Pull complete
afe23e2ce9dd: Pull complete
Digest: sha256:bfa8852e52c279f0857fe8da239c0ad6bbd2cc07793a28a6770f7e24c1e25444
Status: Downloaded newer image for quay.io/keycloak/keycloak:22.0.5
Creating keycloak_mysql ... done
Creating keycloak       ... done
Creating my-app         ... done

# docker-compose ps -a
     Name                   Command               State                          Ports                       
-------------------------------------------------------------------------------------------------------------
keycloak         /opt/keycloak/bin/kc.sh st ...   Up      0.0.0.0:8080->8080/tcp,:::8080->8080/tcp, 8443/tcp 
keycloak_mysql   docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp,:::3306->3306/tcp, 33060/tcp
my-app           /bin/sh /usr/bin/entrypoint.sh   Up      0.0.0.0:3000->3000/tcp,:::3000->3000/tcp           
#
```

* 서비스 확인
```
    Node.js 앱: http://localhost:3000
    Keycloak 관리 콘솔: https://localhost:8443
    MySQL 데이터베이스: localhost:3306

```
