#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
image=$(kubectl get pod genesis-pod -n genesis -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [ "$image" = "localhost:5000/genesis-app:v1" ]; then
  echo "Success: pod uses image localhost:5000/genesis-app:v1"
  exit 0
fi
echo "Error: pod image is '$image', expected localhost:5000/genesis-app:v1"
exit 1
