# 프로젝트 설정 가이드

## 1. 개요
이 문서는 Docker를 사용하여 Node.js 애플리케이션, Keycloak, 그리고 MySQL을 설정하는 방법을 설명합니다.

## 2. 설치 및 실행

### 2.1 컨테이너 및 이미지 상태 확인
```bash
# 실행 중인 컨테이너 확인
docker ps -a

# 도커 이미지 확인
docker images -a
```

### 2.2 기존 컨테이너 및 이미지 정리
```bash
# 실행이 중지된 컨테이너 삭제
docker container prune -f

# 사용되지 않는 도커 이미지 삭제
docker image prune -af
```

### 2.3 도커 이미지 빌드 및 컨테이너 실행
```bash
# 캐시 없이 새롭게 도커 이미지 빌드
docker-compose build --no-cache

# HTTPS를 위한 인증서 생성
cd keycloakiwthIdp/docker
./certpro.sh gen

# 도커 컨테이너 실행
docker-compose up -d
```

### 2.4 인증서 생성 및 P12 파일 가져오기
```bash
./certpro.sh

Usage: ./certpro.sh [command] [options]

[command]
  gen
  extrac [filepath] [pre shared secretkey]
         [filepath] : P12 (or PFX) 파일 위치
         [pre shared secretkey] : P12 파일 생성 시 사용한 비밀번호
```

## 3. 실행 로그 예시
```bash
# docker-compose up -d 실행 결과 예시
Creating network "docker_default" with the default driver
Creating volume "docker_mysql_data" with default driver
Pulling mysql (mysql:8.0)...
Status: Downloaded newer image for mysql:8.0
Pulling keycloak (quay.io/keycloak/keycloak:22.0.5)...
Status: Downloaded newer image for quay.io/keycloak/keycloak:22.0.5
Creating keycloak_mysql ... done
Creating keycloak       ... done
Creating my-app         ... done
```

## 4. 컨테이너 상태 확인
```bash
docker-compose ps -a
```

출력 예시:
```bash
     Name                   Command               State                          Ports                       
-------------------------------------------------------------------------------------------------------------
keycloak         /opt/keycloak/bin/kc.sh st ...   Up      0.0.0.0:8080->8080/tcp,:::8080->8080/tcp, 8443/tcp
keycloak_mysql   docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp,:::3306->3306/tcp, 33060/tcp
my-app           /bin/sh /usr/bin/entrypoint.sh   Up      0.0.0.0:3000->3000/tcp,:::3000->3000/tcp           
```

## 5. 서비스 접속 정보
- **Node.js 애플리케이션**: [http://localhost:3000](http://localhost:3000)
- **Keycloak 관리 콘솔**: [https://localhost:8443](https://localhost:8443)
- **MySQL 데이터베이스**: `localhost:3306`

이제 서비스가 정상적으로 실행되었는지 위의 주소에서 확인하세요.

