#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
resp=$(curl -s "http://localhost:5000/v2/oni-app/tags/list" 2>/dev/null)
case "$resp" in
  *1.0*) echo "Success: image pushed to registry"; exit 0;;
  *) echo "Error: image not found in registry"; exit 1;;
esac
