#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f=/tmp/exam/course/12/nginx-config.txt
if [ -f "$f" ] && grep -q "8080" "$f"; then echo "Success: configuration shows port 8080"; exit 0; else echo "Error: port 8080 not found in file"; exit 1; fi
