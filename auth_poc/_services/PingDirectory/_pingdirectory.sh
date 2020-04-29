#Run 
#ports in use: netstat -a -b

docker run \
           --name pingdirectory \
           --publish 1389:389 \
           --publish 8443:443 \
           -v d:/_dockerVolume/pingdirectory/opt/out:/opt/out\
           -v d:/_dockerVolume/pingdirectory/opt/in:/opt/in\
           --detach \
           --env SERVER_PROFILE_URL=https://github.com/pingidentity/pingidentity-server-profiles.git \
           --env SERVER_PROFILE_PATH=getting-started/pingdirectory\
           pingidentity/pingdirectory:7.3.0.7-edge

docker logs -f pingdirectory 
docker logs --tail 100  pingfederate
docker ps --all
docker start pingdirectory
docker rm pingdirectory
docker stop pingdirectory

# Configure Proxied Authorization for PingFederate 
.\tools\ldapsdk\ldapmodify.bat --defaultAdd --filename add-PFAdmin.ldif -p 1389 -D "cn=administrator" -w 2FederateM0re    
.\tools\ldapsdk\ldapmodify.bat --defaultAdd --filename add-proxy-aci.ldif -p 1389 -D "cn=administrator" -w 2FederateM0re 
   # test
.\tools\ldapsdk\ldapsearch.bat --port 1389 --bindDN "uid=PFAdmin,ou=Applications,dc=example,dc=com"  --bindPassword 2FederateM0re  --proxyAs "dn:uid=user.1,ou=People,dc=example,dc=com"  --baseDN ou=People,dc=example,dc=com  "(uid=user.1)"
     


 keytool -importkeystore -deststorepass [password_from_keystore.pin_file] -destkeypass [password_from_keystore.pin_file] -destkeystore [path_to_PD_keystore_file] -srckeystore [new-PKCS-12-file.p12]] -srcstoretype PKCS12 -destalias new_cert



 manage-certificates import-certificate \
--keystore PD.new \
--keystore-type JKS \ 
--alias server-cert \
--private-key-file PD.key \
--certificate-file PD.crt \ 
--certificate-file root-ca.pem   