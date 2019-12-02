#!/bin/bash

SEUIL=15.0

RAWIN=$(ps -o user,pid,%mem,command ax | grep -v root |grep -v node | grep conda |  sort -bnr -k3 | awk '/[0-9]*/{print $1 ":" $2 ":" $3 ":" $4}')
for i in $RAWIN; do
	PID=$(echo $i | cut -d: -f2)
	MEM=$(echo $i | cut -d: -f3)
	CMD=$(echo $i | cut -d: -f4)
	USR=$(echo $i | cut -d: -f1)
	#if [ $MEM \> $SEUIL ]; then
	if (( $(echo "$MEM > $SEUIL" |bc -l) )); then
		#echo "PID: $PID"
		#echo "MEM: $MEM"
		#echo "CMD: $CMD"
		#echo "USR: $USR"
		kill -9 $PID
		echo "$USR $MEM $CMD" >> /home/log
	fi
done
