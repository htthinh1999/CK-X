#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
rep=$(kubectl get deploy app-deploy -n lyric -o jsonpath='{.spec.replicas}' 2>/dev/null)
if [ "$rep" == "4" ]; then
  echo "Success: app-deploy has 4 replicas"; exit 0
fi
echo "Error: app-deploy replicas='$rep', expected 4"; exit 1
