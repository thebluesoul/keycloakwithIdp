#!/bin/bash

[ "x$DEBUG" = "x1" ] && set -x

function cmd_gen()
{
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

    echo -n "Generating Root CA Key(${ROOT_CA_KEY}):"
    (openssl genrsa -out $ROOT_CA_KEY 2048 >> /dev/null 2>&1)
    echo "  OK."

    echo -n "Generating Root CA Cert(${ROOT_CA_CERT}):"
    openssl req -x509 -new -nodes -key $ROOT_CA_KEY -sha256 -days $DAYS_VALID -out $ROOT_CA_CERT -subj "/C=KR/ST=Seoul/L=Seoul/O=MyOrganization/OU=IT/CN=MyRootCA"
    echo "  OK."

    echo -n "Generating Server Key(${SERVER_KEY}):"
    (openssl genrsa -out $SERVER_KEY 2048 >> /dev/null 2>&1)
    echo "  OK."

    LOCAL_IPADDRESS=`hostname -I | awk '{print $1}' 2>/dev/null`
    >tls.ext cat <<-EOF
    authorityKeyIdentifier=keyid,issuer
    extendedKeyUsage=serverAuth
    basicConstraints=CA:FALSE
    subjectAltName = @alt_names
    [alt_names]
    IP.1=$LOCAL_IPADDRESS
EOF

    echo -n "Generating "
    (openssl req -new -key $SERVER_KEY -out $SERVER_CSR -subj "/C=KR/ST=Seoul/L=Seoul/O=MyOrganization/OU=IT/CN=$SERVER_COMMON_NAME" >> /dev/null 2>&1)

    if [ ! -f "$SERVER_KEY" ]; then
        echo "File not found.(FILE=$SERVER_KEY)"
        exit 1
    else 
        echo "Key File($SERVER_KEY): OK."
    fi

    echo -n "Generating "
    if [ ! -f "$SERVER_CSR" ]; then
        echo "File not found.(FILE=$SERVER_CSR)"
        exit 1
    else 
        echo "CSR File($SERVER_CSR): OK."
    fi

    echo -n "Certificate issuance ${SERVER_CERT}:"
    (openssl x509 -req -in $SERVER_CSR -CA $ROOT_CA_CERT -CAkey $ROOT_CA_KEY -CAcreateserial -out $SERVER_CERT -days $DAYS_VALID -sha256 -extfile tls.ext >> /dev/null 2>&1)
    echo "  OK."
}

function cmd_extrac() 
{
    # 설정 변수
    CERTS_DIR="./certs"

    if [ ! -d $CERTS_DIR ]; then
        mkdir $CERTS_DIR
    fi

    P12_FILE=$2

    if [ "x$P12_FILE" = "x" ]; then
        echo "File not found. (FILE=$P12_FILE)"
        exit 0
    fi

    P12_PASSWORD="$3"
    if [ "x$P12_PASSWORD" = "x" ]; then
        echo "Password is required to extract the certificate from the $P12_FILE file."
        exit 0
    fi
    P12_FILENAME=$(basename "$P12_FILE")
    P12_CACERT="${P12_FILE}.ca.pem"
    P12_CERT_KEY="${P12_FILE}.key"
    P12_CLCERT="${P12_FILE}.pem"

    echo -n "Extracting ${P12_FILE} -> ${P12_CERT_KEY} :"
    openssl pkcs12 -in $P12_FILE -nocerts -nodes -passin pass:"$P12_PASSWORD" | sed -n '/-----BEGIN PRIVATE KEY-----/,$p' > $P12_CERT_KEY
    (cd $CERTS_DIR; ln -sf ${P12_FILENAME}.key server.key)
    echo " OK."

    echo -n "Extracting ${P12_FILE} -> ${P12_CLCERT} :"
    openssl pkcs12 -in $P12_FILE -clcerts -nokeys -passin pass:"$P12_PASSWORD" | sed -n '/-----BEGIN CERTIFICATE-----/,$p' > $P12_CLCERT
    (cd $CERTS_DIR; ln -sf ${P12_FILENAME}.pem server.crt)
    echo " OK."

    echo -n "Extracting ${P12_FILE} -> ${P12_CACERT} :"
    openssl pkcs12 -in $P12_FILE -cacerts -nokeys -passin pass:"$P12_PASSWORD" | sed -n '/-----BEGIN CERTIFICATE-----/,$p' > $P12_CACERT
    (cd $CERTS_DIR; ln -sf ${P12_FILENAME}.ca.pem ca.crt)
    echo " OK."
}

function cmd_help() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "  [command]"
    echo "    gen"
    echo "    extrac [filepath] [pre shared secretkey]"
    echo "           [filepath] : P12 (or PFX) file location"
    echo "           [pre shared secretkey] : Password used during P12 file creation"
}

if [ "x$1" = "x" ]; then
    cmd_help
    exit 0
fi

cmd_$1 "$@"
