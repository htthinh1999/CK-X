#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
p=$(kubectl get svc multi-port-svc -n depths -o jsonpath='{.spec.ports[?(@.port==53)].protocol}' 2>/dev/null)
if [ "$p" = "UDP" ]; then
  echo "Success: port 53 protocol is UDP"; exit 0
fi
echo "Error: port 53 protocol is '$p', expected UDP"; exit 1
