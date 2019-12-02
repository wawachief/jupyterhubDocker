#!/bin/bash

for KILLPID in `ps auxw  | grep 'jupyterhub-singleuser' | grep -v root | awk ' { print $2;}'`; do
	kill -9 $KILLPID
done
