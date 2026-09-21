#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
v=$(kubectl get pod hardened-pod -n predator -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$v" = "secure-app" ]; then echo "Success: container named secure-app"; exit 0; else echo "Error: container='$v' expected secure-app"; exit 1; fi
