#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
p=$(kubectl get secret db-credentials -n storm -o jsonpath='{.data.password}' 2>/dev/null | base64 -d 2>/dev/null)
if [ "$p" = "supersecret123" ]; then echo "Success: password correct"; exit 0; fi
echo "Error: password is '$p', expected supersecret123"; exit 1
