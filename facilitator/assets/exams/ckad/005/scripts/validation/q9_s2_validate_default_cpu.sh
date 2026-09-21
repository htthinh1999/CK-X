#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get limitrange container-limits -n pounce -o jsonpath='{.spec.limits[?(@.type=="Container")].default.cpu}' 2>/dev/null)
if [ "$v" = "500m" ]; then echo "Success: default CPU limit 500m"; exit 0; else echo "Error: default cpu='$v' expected 500m"; exit 1; fi
