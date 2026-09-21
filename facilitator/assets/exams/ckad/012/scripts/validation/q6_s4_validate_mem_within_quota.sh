#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
req=$(kubectl get deployment quota-app -n garrison -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null)
case "$req" in
  256Mi|512Mi|128Mi|384Mi) echo "Success: memory requests within quota ($req)"; exit 0;;
  *) echo "Error: memory requests may exceed quota ($req)"; exit 1;;
esac
