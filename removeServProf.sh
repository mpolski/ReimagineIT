#!/bin/bash

#chck env varialbes for the first three variables
SERVER=$1
USER=$2
PASS=$3
JSONFILE=$4
AUTH=$5
URL="https://$SERVER"

EXTPROFNAME=`cat "$JSONFILE" | jq -r .name`

echo $SERVER $USER $PASS $JSONFILE
echo " "
echo $AUTH
echo ""
echo "Removing profile "$EXTPROFNAME
curl -s -k -H "X-API-Version: 300" -H "Content-Type: application/json" -H "Auth: $AUTH" -X DELETE $URL/rest/server-profiles?filter=name="'$EXTPROFNAME'"
