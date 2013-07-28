#!/bin/bash

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"

free | grep "Mem:" > /tmp/MEM_INFO
free | grep "Swap:" > /tmp/SWAP_INFO

MEM_CAP=`cat /tmp/MEM_INFO | awk '{print $2}'`
MEM_USED=`cat /tmp/MEM_INFO | awk '{print $3}'`
MEM_FREE=`cat /tmp/MEM_INFO | awk '{print $4}'`

SWAP_CAP=`cat /tmp/SWAP_INFO | awk '{print $2}'`
SWAP_USED=`cat /tmp/SWAP_INFO | awk '{print $3}'`
SWAP_FREE=`cat /tmp/SWAP_INFO | awk '{print $4}'`

PREFIX="unix:0:memory:"

echo -e "${PREFIX}mem_cap\tn\t${MEM_CAP}"
echo -e "${PREFIX}mem_free\tn\t${MEM_FREE}"
echo -e "${PREFIX}mem_used\tn\t${MEM_USED}"
echo -e "${PREFIX}swap_cap\tn\t${SWAP_CAP}"
echo -e "${PREFIX}swap_used\tn\t${SWAP_USED}"
echo -e "${PREFIX}swap_used\tn\t${SWAP_FREE}"
