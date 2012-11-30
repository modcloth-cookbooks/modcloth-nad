#!/bin/sh

RNDC="/opt/local/sbin/rndc"
STATS="/var/named/named.stats"

cat /dev/null > ${STATS}

${RNDC} stats

RESPONSES=`cat ${STATS} | grep 'responses sent' | awk '{print $1}'`
SUCCESSFUL=`cat ${STATS} | grep 'successful answer' | awk '{print $1}'`
ERRORS=`cat ${STATS} | grep 'query failures' | awk '{print $1}'`

if [ "${RESPONSES}" = "" ]; then
  RESPONSES="0"
fi

if [ "${SUCCESSFUL}" = "" ]; then
  SUCCESSFUL="0"
fi

if [ "${ERRORS}" = "" ]; then
  ERRORS="0"
fi

PREFIX="unix:0:dns:"

echo "${PREFIX}responses\tn\t${RESPONSES}"
echo "${PREFIX}successful\tn\t${SUCCESSFUL}"
echo "${PREFIX}errors\tn\t${ERRORS}"
