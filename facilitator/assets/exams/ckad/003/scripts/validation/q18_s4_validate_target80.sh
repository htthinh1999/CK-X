#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
t=$(kubectl get service web-svc -n flame -o jsonpath='{.spec.ports[?(@.port==80)].targetPort}' 2>/dev/null)
if [ "$t" = "http-web" ]; then
  echo "Success: port 80 -> http-web"
  exit 0
else
  echo "Error: port 80 targetPort is '$t', expected http-web"
  exit 1
fi
