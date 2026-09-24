#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
u=$(kubectl get secret db-credentials -n storm -o jsonpath='{.data.username}' 2>/dev/null | base64 -d 2>/dev/null)
if [ "$u" = "admin" ]; then echo "Success: username is admin"; exit 0; fi
echo "Error: username is '$u', expected admin"; exit 1
