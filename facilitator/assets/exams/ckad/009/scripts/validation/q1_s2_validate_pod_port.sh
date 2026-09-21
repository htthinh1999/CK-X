#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

port=$(kubectl get pod nginx -n grove -o jsonpath='{.spec.containers[0].ports[0].containerPort}' 2>/dev/null)
if [ "$port" = "80" ]; then
  echo "Success: containerPort 80 configured"; exit 0
else
  echo "Error: containerPort is '$port', expected 80"; exit 1
fi
