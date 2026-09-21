#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
src=$(kubectl get pod webapp -n fortress -o jsonpath='{.spec.containers[0].env[*].valueFrom.secretKeyRef.name}' 2>/dev/null)
case "$src" in
  *db-credentials*) echo "Success: Pod webapp uses secretKeyRef for db-credentials"; exit 0;;
  *) echo "Error: Pod webapp does not use secretKeyRef for db-credentials (got '$src')"; exit 1;;
esac
