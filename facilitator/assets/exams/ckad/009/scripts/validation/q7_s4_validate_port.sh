#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

p=$(kubectl get deployment app-deploy -n root -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}' 2>/dev/null)
if [ "$p" = "80" ]; then
  echo "Success: container port 80 correct"; exit 0
else
  echo "Error: container port is '$p', expected 80"; exit 1
fi
