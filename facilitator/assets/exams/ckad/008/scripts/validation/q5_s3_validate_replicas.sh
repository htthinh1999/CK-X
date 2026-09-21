#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get deployment nginx-deploy -n valley -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$v" = "2" ]; then
  echo "Success: replicas is 2"; exit 0
else
  echo "Error: replicas is '$v', expected 2"; exit 1
fi
