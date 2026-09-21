#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
n=$(kubectl get pod metadata-pod -n claw -o jsonpath='{.spec.containers[0].name}' 2>/dev/null)
if [ "$n" = "info" ]; then echo "Success: container named info"; exit 0; else echo "Error: container='$n' expected info"; exit 1; fi
