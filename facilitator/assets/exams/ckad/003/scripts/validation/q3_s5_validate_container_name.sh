#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cn=$(kubectl get job data-processor -n spark -o jsonpath='{.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$cn" = "processor" ]; then
  echo "Success: container is processor"
  exit 0
else
  echo "Error: container is '$cn', expected processor"
  exit 1
fi
