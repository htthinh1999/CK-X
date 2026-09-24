#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod spread-pod -n eddy -o jsonpath='{.spec.topologySpreadConstraints[0].maxSkew}' 2>/dev/null)
if [ "$v" = "1" ]; then echo "Success: maxSkew is 1"; exit 0; else echo "Error: maxSkew is '$v', expected 1"; exit 1; fi
