#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

content=$(kubectl get secret file-secret -n fern -o jsonpath='{.data.username}' 2>/dev/null | base64 -d 2>/dev/null)
if [ "$content" = "admin" ]; then
  echo "Success: secret content correct"; exit 0
else
  echo "Error: secret username is '$content', expected admin"; exit 1
fi
