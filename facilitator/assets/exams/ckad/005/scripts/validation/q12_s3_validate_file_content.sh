#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f=/tmp/exam/course/12/nginx-config.txt
if [ -f "$f" ] && grep -qi "server\|listen\|location" "$f"; then echo "Success: file contains nginx configuration"; exit 0; else echo "Error: file missing nginx configuration"; exit 1; fi
