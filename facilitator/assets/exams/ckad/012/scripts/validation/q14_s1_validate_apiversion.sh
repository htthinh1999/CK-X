#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
f="/tmp/exam/course/14/broken-deploy.yaml"
if [ ! -s "$f" ]; then echo "Error: $f not found"; exit 1; fi
line=$(grep "apiVersion:" "$f" 2>/dev/null | head -1)
case "$line" in
  *apps/v1*) echo "Success: apiVersion updated to apps/v1"; exit 0;;
  *) echo "Error: apiVersion not updated ($line)"; exit 1;;
esac
