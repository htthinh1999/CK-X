#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ports=$(kubectl get netpol deny-external -n dusk -o jsonpath='{.spec.egress[*].ports[*].port}' 2>/dev/null)
protos=$(kubectl get netpol deny-external -n dusk -o jsonpath='{.spec.egress[*].ports[*].protocol}' 2>/dev/null)
if [ "$ports" == "53" ] && [ "$protos" == "UDP" ]; then
  echo "Success: egress allows only UDP 53"
  exit 0
else
  echo "Error: egress rules incorrect (ports='$ports', protocols='$protos')"
  exit 1
fi
