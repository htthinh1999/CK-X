#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
kubectl get svc mistral-db-headless -n mistral >/dev/null 2>&1 || { echo "Error: Service mistral-db-headless not found in mistral"; exit 1; }
ip=$(kubectl get svc mistral-db-headless -n mistral -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
if [ "$ip" == "None" ]; then
  echo "Success: service is headless (clusterIP None)"
  exit 0
else
  echo "Error: clusterIP='$ip' (expected None)"
  exit 1
fi
