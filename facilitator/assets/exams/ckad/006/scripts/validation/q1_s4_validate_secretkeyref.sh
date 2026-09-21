#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
deploy=$(kubectl get deploy api-server -n stream -o yaml 2>/dev/null)
if echo "$deploy" | grep -q "secretKeyRef"; then echo "Success: deployment api-server uses secretKeyRef"; exit 0; else echo "Error: deployment api-server does not use secretKeyRef"; exit 1; fi
