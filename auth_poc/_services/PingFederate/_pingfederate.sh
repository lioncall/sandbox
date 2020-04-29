#Run 
#ports in use: netstat -a -b

docker run  --name pingfederate --publish 9999:9999 --publish 9031:9031 --publish 9032:9032 -v d:/_dockerVolume/pingfederate:/opt/out --detach  --env SERVER_PROFILE_URL=https://github.com/pingidentity/pingidentity-server-profiles.git  --env SERVER_PROFILE_PATH=getting-started/pingfederate   pingidentity/pingfederate:edge
docker logs -f pingfederate
docker logs --tail 100  pingfederate
docker container inspect pingfederate
docker ps --all
docker start pingfederate
docker stop pingfederate
docker rm pingfederate


curl -k -u administrator:2FederateM0re -X GET \
  https://localhost:9999/pf-admin-api/v1/license \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache'


# Create greenway.sso.service scope 
# curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X DELETE \
#   https://localhost:9999/pf-admin-api/v1/oauth/authServerSettings/scopes/exclusiveScopes/greenway.sso.service \
#   -H 'X-Xsrf-Header: PingFederate' \
#   -H 'cache-control: no-cache'

curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X POST \
  https://localhost:9999/pf-admin-api/v1/oauth/authServerSettings/scopes/exclusiveScopes \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 99' \
  -H 'Content-Type: application/json' \
  -H 'Host: localhost:9999' \
  -H 'User-Agent: PostmanRuntime/7.15.2' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
  "name": "greenway.sso.service",
  "description": "greenway.sso.service",
  "dynamic": "false"
}'
 

#Create greenway.sso.service  client
# curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X DELETE \
#   https://localhost:9999/pf-admin-api/v1/oauth/clients/greenway.sso.service \
#   -H 'X-Xsrf-Header: PingFederate' \
#   -H 'cache-control: no-cache'

curl  -k -u administrator:7893a422dAFab856705dd88c3310265e -X POST \
  https://localhost:9999/pf-admin-api/v1/oauth/clients \
  -H 'Content-Type: application/json' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
  "clientId": "greenway.sso.service",
  "redirectUris": [],
  "grantTypes": [
    "ACCESS_TOKEN_VALIDATION"
  ],
  "name": "greenway.sso.service",
  "description": "",
  "logoUrl": "",
  "validateUsingAllEligibleAtms": false,
  "refreshRolling": "SERVER_DEFAULT",
  "persistentGrantExpirationType": "SERVER_DEFAULT",
  "persistentGrantExpirationTime": 0,
  "persistentGrantExpirationTimeUnit": "DAYS",
  "bypassApprovalPage": false,
  "restrictScopes": false,
  "restrictedScopes": [],
 "requireSignedRequests": false,
  "clientAuth": {
    "type": "SECRET",
    "secret": "greenway.sso.service.secret", 
    "enforceReplayPrevention": false
  } 
}'

#Create greenway.ui  client
# curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X DELETE \
#   https://localhost:9999/pf-admin-api/v1/oauth/clients/greenway.ui \
#   -H 'X-Xsrf-Header: PingFederate' \
#   -H 'cache-control: no-cache'

curl  -k -u administrator:7893a422dAFab856705dd88c3310265e -X POST \
  https://localhost:9999/pf-admin-api/v1/oauth/clients \
  -H 'Content-Type: application/json' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
  "clientId": "greenway.ui",
  "redirectUris": [],
  "grantTypes": [
    "CLIENT_CREDENTIALS"
  ],
  "name": "greenway.ui",
  "description": "",
  "logoUrl": "",
  "validateUsingAllEligibleAtms": false,
  "refreshRolling": "SERVER_DEFAULT",
  "persistentGrantExpirationType": "SERVER_DEFAULT",
  "persistentGrantExpirationTime": 0,
  "persistentGrantExpirationTimeUnit": "DAYS",
  "bypassApprovalPage": false,
  "restrictScopes": false,
  "restrictedScopes": [],
  "exclusiveScopes": [
        "greenway.sso.service" 
  ],
  "requireSignedRequests": false,
  "clientAuth": {
    "type": "SECRET",
    "secret": "greenway.ui.secret", 
    "enforceReplayPrevention": false
  } 
}'
 

 # Access token manager
#  curl  -k -u administrator:7893a422dAFab856705dd88c3310265e -X DELETE \
#   https://localhost:9999/pf-admin-api/v1/oauth/accessTokenManagers/atm01 \
#   -H 'Accept: */*' \
#   -H 'Accept-Encoding: gzip, deflate' \
#   -H 'Authorization: Basic QWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' \
#   -H 'Cache-Control: no-cache' \
#   -H 'Connection: keep-alive' \
#   -H 'Content-Length: ' \
#   -H 'Host: localhost:9999' \
#   -H 'X-Xsrf-Header: PingFederate' \
#   -H 'cache-control: no-cache'

  curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X POST \
  https://localhost:9999/pf-admin-api/v1/oauth/accessTokenManagers \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Authorization: Basic QWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 2239' \
  -H 'Content-Type: application/json' \
  -H 'Host: localhost:9999' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
    "id": "atm01",
    "name": "atm01",
    "pluginDescriptorRef": {
        "id": "org.sourceid.oauth20.token.plugin.impl.ReferenceBearerAccessTokenManagementPlugin",
        "location": "https://fd18499145d3:9999/pf-admin-api/v1/oauth/accessTokenManagers/descriptors/org.sourceid.oauth20.token.plugin.impl.ReferenceBearerAccessTokenManagementPlugin"
    },
    "configuration": {
        "tables": [],
        "fields": [
            {
                "name": "Token Length",
                "value": "28"
            },
            {
                "name": "Token Lifetime",
                "value": "120"
            },
            {
                "name": "Lifetime Extension Policy",
                "value": "NONE"
            },
            {
                "name": "Maximum Token Lifetime",
                "value": ""
            },
            {
                "name": "Lifetime Extension Threshold Percentage",
                "value": "30"
            },
            {
                "name": "Mode for Synchronous RPC",
                "value": "3"
            },
            {
                "name": "RPC Timeout",
                "value": "500"
            },
            {
                "name": "Expand Scope Groups",
                "value": "false"
            }
        ]
    },
    "attributeContract": {
        "coreAttributes": [],
        "extendedAttributes": [
            {
                "name": "user_key"
            }
        ]
    },
    "selectionSettings": {
        "resourceUris": []
    },
    "accessControlSettings": {
        "restrictClients": true,
        "allowedClients": [
            {
                "id": "greenway.sso.service",
                "location": "https://fd18499145d3:9999/pf-admin-api/v1/oauth/clients/greenway.sso.service"
            },
            {
                "id": "greenway.ui",
                "location": "https://fd18499145d3:9999/pf-admin-api/v1/oauth/clients/greenway.ui"
            }
        ]
    },
    "sessionValidationSettings": {
        "checkValidAuthnSession": false,
        "checkSessionRevocationStatus": false,
        "updateAuthnSessionActivity": false
    }
}'

curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X PUT \
  https://localhost:9999/pf-admin-api/v1/oauth/accessTokenManagers/settings \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: gzip, deflate' \
  -H 'Authorization: Basic QWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 171' \
  -H 'Content-Type: application/json' \
  -H 'Host: localhost:9999' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
    "defaultAccessTokenManagerRef": {
        "id": "atm01",
        "location": "https://fd18499145d3:9999/pf-admin-api/v1/oauth/accessTokenManagers/atm01"
    }
}'

# curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X DELETE \
#   https://localhost:9999/pf-admin-api/v1/oauth/accessTokenMappings/client_credentials|atm01 \
#   -H 'Accept: */*' \
#   -H 'Accept-Encoding: gzip, deflate' \
#   -H 'Authorization: Basic QWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' \
#   -H 'Cache-Control: no-cache' \
#   -H 'Connection: keep-alive' \
#   -H 'Content-Length: ' \
#   -H 'Host: localhost:9999' \
#   -H 'Postman-Token: 5956c8e1-260f-44d1-a23b-97ed5be9e54c,8cd112d3-a2cc-4388-9f07-baa81a9cb332' \
#   -H 'User-Agent: PostmanRuntime/7.15.2' \
#   -H 'X-Xsrf-Header: PingFederate' \
#   -H 'cache-control: no-cache'


curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X POST \
  https://localhost:9999/pf-admin-api/v1/oauth/accessTokenMappings \
  -H 'Content-Type: application/json' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
    "id": "client_credentials_atm01",
    "context": {
        "type": "CLIENT_CREDENTIALS"
    },
    "attributeSources": [],
    "attributeContractFulfillment": {
        "user_key": {
            "source": {
                "type": "CONTEXT"
            },
            "value": "OAuthScopes"
        }
    },
    "issuanceCriteria": {
        "conditionalCriteria": []
    },
    "accessTokenManagerRef": {
        "id": "atm01",
        "location": "https://fd18499145d3:9999/pf-admin-api/v1/oauth/accessTokenManagers/atm01"
    }
}'
 

  curl -k -u administrator:7893a422dAFab856705dd88c3310265e  -X POST \
   https://localhost:9999/pf-admin-api/v1/idp/adapters \
  -H 'Content-Type: application/json' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
    "id": "ableHealthSsoAdapter",
    "name": "Able Health SSO Adapter",
    "pluginDescriptorRef": {
        "id": "com.pingidentity.pf.adapters.referenceid.IdpBackchannelReferenceAuthnAdapter",
        "location": "https://4483bd0bcb86:9999/pf-admin-api/v1/idp/adapters/descriptors/com.pingidentity.pf.adapters.referenceid.IdpBackchannelReferenceAuthnAdapter"
    },
    "configuration": {
        "tables": [],
        "fields": [
            {
                "name": "Authentication Endpoint",
                "value": "https://localhost"
            },
            {
                "name": "User Name",
                "value": "ssoServiceUser"
            },
            {
                "name": "Pass Phrase",
                "value": "ssoServicePassword" 
            },
            {
                "name": "Allowed Subject DN",
                "value": "CN=localhost"
            },
            {
                "name": "Allowed Issuer DN",
                "value": ""
            },
            {
                "name": "Logout Service Endpoint",
                "value": ""
            },
            {
                "name": "Prefix Referenced Attributes",
                "value": "true"
            },
            {
                "name": "Ignore Untracked HTTP Parameters",
                "value": "true"
            },
            {
                "name": "Transport Mode",
                "value": "0"
            },
            {
                "name": "Reference Duration",
                "value": "3"
            },
            {
                "name": "Reference Length",
                "value": "30"
            },
            {
                "name": "Require SSL/TLS",
                "value": "false"
            },
            {
                "name": "Outgoing Attribute Format",
                "value": "JSON"
            },
            {
                "name": "Incoming Attribute Format",
                "value": "JSON"
            },
            {
                "name": "Logout Mode",
                "value": "BACK"
            },
            {
                "name": "Skip Host Name Validation ",
                "value": "true"
            }
        ]
    },
    "attributeContract": {
        "coreAttributes": [
            {
                "name": "subject",
                "masked": false,
                "pseudonym": true
            }
        ],
        "extendedAttributes": [
            {
                "name": "address",
                "masked": false,
                "pseudonym": false
            },
            {
                "name": "name",
                "masked": false,
                "pseudonym": false
            }
        ],
        "maskOgnlValues": false
    },
    "attributeMapping": {
        "attributeSources": [],
        "attributeContractFulfillment": {
            "address": {
                "source": {
                    "type": "ADAPTER"
                },
                "value": "address"
            },
            "subject": {
                "source": {
                    "type": "ADAPTER"
                },
                "value": "subject"
            },
            "name": {
                "source": {
                    "type": "ADAPTER"
                },
                "value": "name"
            }
        },
        "issuanceCriteria": {
            "conditionalCriteria": []
        }
    }
}'




curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X PUT \
  https://localhost:9999/pf-admin-api/v1/serverSettings \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
    "contactInfo": {},
    "rolesAndProtocols": {
        "oauthRole": {
            "enableOauth": true,
            "enableOpenIdConnect": true
        },
        "idpRole": {
            "enable": true,
            "enableSaml11": false,
            "enableSaml10": false,
            "enableWsFed": false,
            "enableWsTrust": false,
            "saml20Profile": {
                "enable": true
            },
            "enableOutboundProvisioning": false
        },
        "spRole": {
            "enable": false,
            "enableSaml11": false,
            "enableSaml10": false,
            "enableWsFed": false,
            "enableWsTrust": false,
            "saml20Profile": {
                "enable": false,
                "enableXASP": false
            },
            "enableInboundProvisioning": false,
            "enableOpenIDConnect": false
        },
        "enableIdpDiscovery": false
    },
    "federationInfo": {
        "baseUrl": "https://localhost:9031",
        "saml2EntityId": "evaluation",
        "saml1xIssuerId": "",
        "saml1xSourceId": "",
        "wsfedRealm": ""
    },
    "notifications": {
        "notifyAdminUserPasswordChanges": false
    }
}'

curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X POST \
  https://localhost:9999/pf-admin-api/v1/authenticationPolicyContracts \
  -H 'Content-Type: application/json' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
    "id": "ableHealth",
    "name": "ableHealth",
    "coreAttributes": [
        {
            "name": "subject"
        }
    ],
    "extendedAttributes": [
        {
            "name": "address"
        },
        {
            "name": "name"
        }
    ]
}'

curl -k -u administrator:7893a422dAFab856705dd88c3310265e -X POST \
  https://localhost:9999/pf-admin-api/v1/idp/spConnections \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 2e94d4fe-2da1-47c3-ab27-cadc78377c7a' \
  -H 'X-Xsrf-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
    "type": "SP",
    "id": "partner.ui",
    "name": "partner.ui",
    "entityId": "partner.ui",
    "active": true,
    "contactInfo": {},
    "baseUrl": "https://sso-partner-ui.dev1210.aws.greenwayhealth.com",
    "loggingMode": "FULL",
    "virtualEntityIds": [],
    "licenseConnectionGroup": "",
    "credentials": {
        "certs": [],
        "signingSettings": {
            "signingKeyPairRef": {
                "id": "npnmznt4lxmjzdd60hjkj4ss9",
                "location": "https://4483bd0bcb86:9999/pf-admin-api/v1/keyPairs/signing/npnmznt4lxmjzdd60hjkj4ss9"
            },
            "includeCertInSignature": false,
            "includeRawKeyInSignature": false,
            "algorithm": "SHA256withRSA"
        }
    },
    "spBrowserSso": {
        "protocol": "SAML20",
        "enabledProfiles": [
            "IDP_INITIATED_SSO"
        ],
        "ssoServiceEndpoints": [
            {
                "binding": "POST",
                "url": "https://sso-partner-ui.dev1210.aws.greenwayhealth.com/SAML/AssertionConsumerService",
                "isDefault": true,
                "index": 0
            }
        ],
        "signAssertions": false,
        "signResponseAsRequired": true,
        "spSamlIdentityMapping": "STANDARD",
        "requireSignedAuthnRequests": false,
        "assertionLifetime": {
            "minutesBefore": 5,
            "minutesAfter": 5
        },
        "encryptionPolicy": {
            "encryptAssertion": false,
            "encryptSloSubjectNameId": false,
            "sloSubjectNameIDEncrypted": false,
            "encryptedAttributes": []
        },
        "attributeContract": {
            "coreAttributes": [
                {
                    "name": "SAML_SUBJECT",
                    "nameFormat": "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
                }
            ],
            "extendedAttributes": [
                {
                    "name": "name",
                    "nameFormat": "urn:oasis:names:tc:SAML:2.0:attrname-format:basic"
                },
                {
                    "name": "address",
                    "nameFormat": "urn:oasis:names:tc:SAML:2.0:attrname-format:basic"
                },
                {
                    "name": "subject",
                    "nameFormat": "urn:oasis:names:tc:SAML:2.0:attrname-format:basic"
                }
            ]
        },
        "adapterMappings": [
            {
                "attributeSources": [],
                "attributeContractFulfillment": {
                    "address": {
                        "source": {
                            "type": "ADAPTER"
                        },
                        "value": "address"
                    },
                    "subject": {
                        "source": {
                            "type": "ADAPTER"
                        },
                        "value": "subject"
                    },
                    "name": {
                        "source": {
                            "type": "ADAPTER"
                        },
                        "value": "name"
                    },
                    "SAML_SUBJECT": {
                        "source": {
                            "type": "ADAPTER"
                        },
                        "value": "subject"
                    }
                },
                "issuanceCriteria": {
                    "conditionalCriteria": []
                },
                "restrictVirtualEntityIds": false,
                "restrictedVirtualEntityIds": [],
                "idpAdapterRef": {
                    "id": "ableHealthSsoAdapter",
                    "location": "https://4483bd0bcb86:9999/pf-admin-api/v1/idp/adapters/ableHealthSsoAdapter"
                },
                "abortSsoTransactionAsFailSafe": false
            }
        ],
        "authenticationPolicyContractAssertionMappings": [
            {
                "attributeSources": [],
                "attributeContractFulfillment": {
                    "address": {
                        "source": {
                            "type": "AUTHENTICATION_POLICY_CONTRACT"
                        },
                        "value": "address"
                    },
                    "subject": {
                        "source": {
                            "type": "AUTHENTICATION_POLICY_CONTRACT"
                        },
                        "value": "subject"
                    },
                    "name": {
                        "source": {
                            "type": "AUTHENTICATION_POLICY_CONTRACT"
                        },
                        "value": "name"
                    },
                    "SAML_SUBJECT": {
                        "source": {
                            "type": "AUTHENTICATION_POLICY_CONTRACT"
                        },
                        "value": "subject"
                    }
                },
                "issuanceCriteria": {
                    "conditionalCriteria": []
                },
                "authenticationPolicyContractRef": {
                    "id": "ableHealth",
                    "location": "https://4483bd0bcb86:9999/pf-admin-api/v1/authenticationPolicyContracts/ableHealth"
                },
                "restrictVirtualEntityIds": false,
                "restrictedVirtualEntityIds": [],
                "abortSsoTransactionAsFailSafe": false
            }
        ]
    }
}'