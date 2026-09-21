#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

val=$(kubectl get pod tolerate-pod -n moss -o jsonpath='{.spec.tolerations[?(@.key=="tier")].value}' 2>/dev/null)
if [ "$val" = "frontend" ]; then
  echo "Success: toleration value frontend correct"; exit 0
else
  echo "Error: toleration value is '$val', expected frontend"; exit 1
fi
