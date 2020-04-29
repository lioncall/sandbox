
#create dev-certs
dotnet dev-certs https --clean
dotnet dev-certs https -t
dotnet dev-certs https -ep
dotnet dev-certs https --export-path devcert.crt

#Configure certificate authentication
https://support.pingidentity.com/s/document-item?bundleId=integrations&topicId=cyh1563994985135.html

#rootCA
openssl genrsa -out rootCA.key 1024
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem

#
req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout privateKey.key -out certificate.crt

#PingDirectory Service
openssl genrsa -out PD.key 2048
openssl req -new -sha256 -key PD.key  -out PD.csr
openssl req -in PD.csr -noout -text
openssl x509 -req -in PD.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out PD.crt -days 500 -sha256
openssl pkcs12 -export -out PD.pfx -inkey PD.key -in PD.crt 
openssl pkcs12 -in PD.pfx -nocerts -out PD.key.pem -nodes
openssl pkcs12 -in PD.pfx -nokeys -out PD.cert.pem -nodes
 openssl pkcs12 -export -out [new-PKCS-12-file.p12]  -in [certificate-file] -inkey [private-key-file] -certfile [CA_certificate_chain_bundle] -name new_cert
 