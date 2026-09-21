#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

v=$(kubectl get cm app-config -n peak -o jsonpath='{.data.foo2}' 2>/dev/null)
if [ "$v" = "lolo" ]; then
  echo "Success: foo2 is lolo"; exit 0
else
  echo "Error: foo2 is '$v', expected lolo"; exit 1
fi
