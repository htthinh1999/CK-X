#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
port=$(kubectl get deployment broken-app -n anchor -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}' 2>/dev/null)
if [[ "$port" == "80" ]]; then
  echo "Success: containerPort corrected to 80"
  exit 0
fi
echo "Error: containerPort is '$port', expected 80"
exit 1
