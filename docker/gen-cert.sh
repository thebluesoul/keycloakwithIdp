#!/bin/bash

# 설정 변수
CERTS_DIR="./certs"
ROOT_CA_KEY="${CERTS_DIR}/rootCA.key"
ROOT_CA_CERT="${CERTS_DIR}/rootCA.crt"
SERVER_KEY="${CERTS_DIR}/server.key"
SERVER_CSR="${CERTS_DIR}/server.csr"
SERVER_CERT="${CERTS_DIR}/server.crt"
SERVER_COMMON_NAME=`hostname -I | awk '{print $1}' 2>/dev/null`
DAYS_VALID=365

if [ ! -d $CERTS_DIR ]; then
    mkdir $CERTS_DIR
fi

# 1. 루트 CA 개인 키 생성
echo "=== 루트 CA 개인 키 생성 ==="
openssl genrsa -out $ROOT_CA_KEY 4096

# 2. 루트 CA 인증서 생성
echo "=== 루트 CA 인증서 생성 ==="
openssl req -x509 -new -nodes -key $ROOT_CA_KEY -sha256 -days $DAYS_VALID -out $ROOT_CA_CERT -subj "/C=KR/ST=Seoul/L=Seoul/O=MyOrganization/OU=IT/CN=MyRootCA"

# 3. 서버 개인 키 생성
echo "=== 서버 개인 키 생성 ==="
openssl genrsa -out $SERVER_KEY 2048

# 4. 서버 인증서 서명 요청(CSR) 생성
echo "=== 서버 인증서 서명 요청(CSR) 생성 ==="
openssl req -new -key $SERVER_KEY -out $SERVER_CSR -subj "/C=KR/ST=Seoul/L=Seoul/O=MyOrganization/OU=IT/CN=$SERVER_COMMON_NAME"

# 5. 루트 CA로 서버 인증서 서명
echo "=== 루트 CA로 서버 인증서 서명 ==="
openssl x509 -req -in $SERVER_CSR -CA $ROOT_CA_CERT -CAkey $ROOT_CA_KEY -CAcreateserial -out $SERVER_CERT -days $DAYS_VALID -sha256

# 결과 출력
echo "=== 생성된 인증서 파일 ==="
echo "Root CA Key: $ROOT_CA_KEY"
echo "Root CA Cert: $ROOT_CA_CERT"
echo "Server Key: $SERVER_KEY"
echo "Server CSR: $SERVER_CSR"
echo "Server Cert: $SERVER_CERT"
