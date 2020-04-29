docker stop 145ede136c53
docker ps --all
docker image ls
docker start 145ede136c53

docker cp 145ede136c53:/tmp/ping-install/entrypoint.sh ./entrypoint.sh
docker cp 145ede136c53:/tmp/ping-install/admin_config.sh ./admin_config.sh
docker cp 145ede136c53:/tmp/ping-install/customDataStore.json ./customDataStore.json
docker cp 145ede136c53:/tmp/ping-install/validateUserAdapter.json ./validateUserAdapter.json
docker cp 145ede136c53:/tmp/ping-install/practiceSelectAdapterV2.json ./practiceSelectAdapterV2.json
docker cp 145ede136c53:/tmp/ping-install/redirectValidation.json ./redirectValidation.json
docker cp 145ede136c53:/tmp/ping-install/serverSettings.json ./serverSettings.json
docker cp 513b2c77c63a:/tmp/ping-install/routing.demo-polaris110.json ./routing.demo-polaris110.json
docker cp 513b2c77c63a:/tmp/ping-install/mvc.json ./mvc.json
docker cp 145ede136c53:/tmp/ping-install/Custom-5A9685A366E48F35F05EEFA58625BD7AD83A4064.xml ./Custom-5A9685A366E48F35F05EEFA58625BD7AD83A4064.xml

docker cp ./admin_config.sh  145ede136c53:/tmp/ping-install/admin_config.sh 
docker cp ./customDataStore.json 145ede136c53:/tmp/ping-install/customDataStore.json 
docker cp ./validateUserAdapter.json 145ede136c53:/tmp/ping-install/validateUserAdapter.json 
docker cp ./practiceSelectAdapterV2.json 145ede136c53:/tmp/ping-install/practiceSelectAdapterV2.json 
docker cp ./redirectValidation.json 145ede136c53:/tmp/ping-install/redirectValidation.json 
docker cp ./serverSettings.json 145ede136c53:/tmp/ping-install/serverSettings.json   
docker cp ./Custom-5A9685A366E48F35F05EEFA58625BD7AD83A4064.xml 145ede136c53:/tmp/ping-install/Custom-5A9685A366E48F35F05EEFA58625BD7AD83A4064.xml 

#copy agentless(sso) adapter to image
docker cp ./pf-referenceid-adapter-1.5.2.jar 88884da60220:/usr/share/pingfederate/server/default/deploy

 
docker rmi auth-token-server-withssoadapter 
docker commit  --change='ENTRYPOINT ["./entrypoint.sh"]' 88884da60220 auth-token-server-withssoadapter
docker image ls
docker image inspect auth-token-server-withssoadapter
docker tag auth-token-server-withssoadapter 389934990668.dkr.ecr.us-east-2.amazonaws.com/johann/auth-token-server
aws ecr get-login --no-include-email
docker push 389934990668.dkr.ecr.us-east-2.amazonaws.com/johann/auth-token-server

aws ecs describe-services --cluster auth-token-server-admin --service auth-token-server-admin --output table --query 'services[*].{deploymentConfiguration:deploymentConfiguration,deployments:deployments}'
aws ecs update-service --cluster auth-token-server-admin --service auth-token-server-admin --force-new-deployment