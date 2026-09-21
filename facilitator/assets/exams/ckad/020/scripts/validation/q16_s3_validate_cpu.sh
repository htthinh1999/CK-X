#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cpu=$(kubectl get resourcequota priority-quota -n eden -o jsonpath='{.spec.hard.requests\.cpu}' 2>/dev/null)
if [ "$cpu" = "2" ]; then
  echo "Success: hard requests.cpu is 2"
  exit 0
fi
echo "Error: hard requests.cpu is '$cpu', expected 2"
exit 1
