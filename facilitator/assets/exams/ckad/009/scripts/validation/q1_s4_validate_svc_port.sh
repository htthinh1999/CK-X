#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig

port=$(kubectl get svc nginx -n grove -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
if [ "$port" = "80" ]; then
  echo "Success: service port 80 correct"; exit 0
else
  echo "Error: service port is '$port', expected 80"; exit 1
fi
