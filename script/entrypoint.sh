#!/bin/sh

if [ -n "${SERVICE_PUBLIC_URL}" ]; then
  jq '.servicePublicURL="'${SERVICE_PUBLIC_URL}'"' config.json > tmp.json && mv tmp.json config.json
fi

if [ -n "${WWW_PUBLIC_URL}" ]; then
  jq '.wwwPublicURL="${WWW_PUBLIC_URL}"' config.json > tmp.json && mv tmp.json config.json
fi

#./mailslurper