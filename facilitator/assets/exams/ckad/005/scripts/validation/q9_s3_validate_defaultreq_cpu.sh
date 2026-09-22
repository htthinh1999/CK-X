#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get limitrange container-limits -n pounce -o jsonpath='{.spec.limits[?(@.type=="Container")].defaultRequest.cpu}' 2>/dev/null)
if [ "$v" = "100m" ]; then echo "Success: default CPU request 100m"; exit 0; else echo "Error: defaultRequest cpu='$v' expected 100m"; exit 1; fi
