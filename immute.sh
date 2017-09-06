#!/bin/bash

SERVER=$1
USER=$2
PASS=$3
PROFILE=$4
#Get the exact profile name from the supplied .json file
EXTPROFNAME=`cat "$PROFILE" | jq -r .name`
URL="https://$SERVER"

#Authenticate to HPE OneView API
AUTH=`curl -s -k -H "X-API-Version: 300" -H "Content-Type: application/json" -d '{"userName":"'$USER'","password":"'$PASS'","loginMsgAck":"true"}' POST $URL/rest/login-sessions | jq -r .sessionID`

#Gets the existing profile names (currently expected to work with 1 profile only) 
SPNAME=`curl -s -k -H "X-API-Version: 300" -H "Content-Type: application/json" -H "Auth: $AUTH" -X GET $URL/rest/server-profiles | jq -r '.members | .[].name'`

#Compares whether the profile we want to add is already running
#if yes, then it destroys the profile by calling an external script, waits some seconds for the profile to be destroyed and applies the new version of the profile
#if no, logs information
if [ "$SPNAME" == "$EXTPROFNAME" ]; 
 then
   echo "Profile $EXTPROFNAME exists! Destroying $EXTPROFNAME......."
   echo "`./removeServProf.sh $SERVER $USER $PASS $PROFILE $AUTH`";
   echo "`sleep 85`"
 else
   echo "Nothing to destroy, provisioning infrastructure";
fi

