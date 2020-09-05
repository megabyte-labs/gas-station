#!/bin/bash
export HOST=workstation.lab.megabyte.space
mkdir -pv ~/.docker
cd ~/.docker
openssl genrsa -aes256 -passout file:~/.docker/.cert-password -out docker-ca-key.pem 4096
openssl req -new -passin file:~/.docker/.cert-password -subj '/C=US/ST=New Jersey/L=The Hood/O=Megabyte LLC/OU=Home Lab/CN=$HOST' -x509 -days 365 -key docker-ca-key.pem -sha256 -out docker-ca.pem
openssl genrsa -out docker-server-key.pem 4096
openssl req -subj "/CN=$HOST" -sha256 -new -key docker-server-key.pem -out docker-server.csr
echo subjectAltName = DNS:$HOST,IP:10.14.14.14,IP:127.0.0.1 >> extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf
openssl x509 -req -days 365 -sha256 -in docker-server.csr -CA docker-ca.pem -CAkey docker-ca-key.pem -passin file:~/.docker/.cert-password -CAcreateserial -out docker-server-cert.pem -extfile extfile.cnf
openssl genrsa -out docker-key.pem 4096
openssl req -subj '/CN=client' -new -key docker-key.pem -out docker-client.csr
echo extendedKeyUsage = clientAuth > extfile-client.cnf
openssl x509 -req -days 365 -sha256 -in docker-client.csr -CA docker-ca.pem -CAkey docker-ca-key.pem -passin file:~/.docker/.cert-password -CAcreateserial -out docker-cert.pem -extfile extfile-client.cnf
rm -v docker-client.csr docker-server.csr extfile.cnf extfile-client.cnf
chmod -v 0400 docker-ca-key.pem docker-key.pem docker-server-key.pem
chmod -v 0444 docker-ca.pem docker-server-cert.pem docker-cert.pem
mv docker-server-*.pem /etc/ssl/private
mv docker-ca.pem /etc/ssl/private