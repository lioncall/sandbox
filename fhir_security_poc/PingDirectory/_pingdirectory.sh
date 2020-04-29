 
docker run -it --entrypoint "sh" pingidentity/pingdirectory:7.3.0.7-edge
docker run \
           --name pingdirectory2 \
           --publish 3389:389 \
           --publish 9443:443 \
           -v d:/_dockerVolume/pingdirectory2/opt/out:/opt/out\
           -v d:/_dockerVolume/pingdirectory2/opt/in:/opt/in\
           --detach \
           --env SERVER_PROFILE_URL=https://github.com/pingidentity/pingidentity-server-profiles.git \
           --env SERVER_PROFILE_PATH=getting-started/pingdirectory\
           pingidentity/pingdirectory:7.3.0.7-edge

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

# connect with PF
# 1 Configure Proxied Authorization for PingFederate 
.\tools\ldapsdk\ldapmodify.bat --defaultAdd --filename add-PFAdmin.ldif -p 1389 -D "cn=administrator" -w 2FederateM0re    
.\tools\ldapsdk\ldapmodify.bat --defaultAdd --filename add-proxy-aci.ldif -p 1389 -D "cn=administrator" -w 2FederateM0re 
   # test
.\tools\ldapsdk\ldapsearch.bat --port 1389 --bindDN "uid=PFAdmin,ou=Applications,dc=example,dc=com"  --bindPassword 2FederateM0re  --proxyAs "dn:uid=user.1,ou=People,dc=example,dc=com"  --baseDN ou=People,dc=example,dc=com  "(uid=user.1)"
     
# 2 Get the PD SSL cert
keytool -exportcert -keystore config/keystore -storepass '2FederateM0re' -alias server-cert -rfc -file ~/tmp/pd-localhost.crt

docker exec -it a0038dbc4e34 sh  



manage-certificates list-certificates --keystore config/keystore