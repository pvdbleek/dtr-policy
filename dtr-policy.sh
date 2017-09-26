#!/bin/sh

if [[ "$DTR_URL" == "" ]]; then
   echo "DTR_URL environment variable not set, exiting!"
   exit 1
fi

if [[ "$DTR_USER" == "" ]]; then
   echo "DTR_USER environment variable not set, exiting!"
   exit 1
fi

DTR_PASSWD=$(cat /run/secrets/dtr_passwd)

for repodata in `curl -s -k -X GET -u ${DTR_USER}:${DTR_PASSWD} --header "Accept: application/json" "${DTR_URL}/api/v0/repositories?count=false" | jq -r '.repositories[] | [ .namespace, .name, .visibility, .scanOnPush ] | @csv' | sed 's/"//g'`
  do
    score=0
    NAMESPACE=`echo $repodata | awk -F, '{print $1}'`
    REPO=`echo $repodata | awk -F, '{print $2}'`
    VISIBILITY=`echo $repodata | awk -F, '{print $3}'`
    SCAN=`echo $repodata | awk -F, '{print $4}'`
    [ "$VISIBILITY" != "private" ] && score=$((score+1))
    [ "$SCAN" != "true" ] && score=$((score+1))
    if [ $score -gt 0 ]; then
       echo "";echo "Repository ${NAMESPACE}/${REPO} has visibility set to ${VISIBILITY} and scanOnPush set to ${SCAN}, applying policy."
       curl -s -k -X PATCH -u ${DTR_USER}:${DTR_PASSWD} --header "Content-Type: application/json" --header "Accept: application/json" -d "{\"visibility\": \"private\",\"scanOnPush\": true}" "${DTR_URL}/api/v0/repositories/${NAMESPACE}/${REPO}"
    fi
  done
