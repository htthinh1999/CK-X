#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
s=$(kubectl get cj data-sync -n coral -o jsonpath='{.spec.schedule}' 2>/dev/null)
if [ "$s" = "*/10 * * * *" ]; then
  echo "Success: schedule is '*/10 * * * *'"; exit 0
fi
echo "Error: schedule is '$s', expected '*/10 * * * *'"; exit 1
