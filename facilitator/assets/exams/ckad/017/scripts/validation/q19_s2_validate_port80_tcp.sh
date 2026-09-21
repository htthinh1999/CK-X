#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
p=$(kubectl get svc multi-port-svc -n depths -o jsonpath='{.spec.ports[?(@.port==80)].protocol}' 2>/dev/null)
if [ "$p" = "TCP" ]; then
  echo "Success: port 80 protocol is TCP"; exit 0
fi
echo "Error: port 80 protocol is '$p', expected TCP"; exit 1
