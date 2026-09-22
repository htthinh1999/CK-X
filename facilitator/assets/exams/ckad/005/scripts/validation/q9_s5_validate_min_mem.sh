#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get limitrange container-limits -n pounce -o jsonpath='{.spec.limits[?(@.type=="Container")].min.memory}' 2>/dev/null)
if [ "$v" = "32Mi" ]; then echo "Success: min memory 32Mi"; exit 0; else echo "Error: min memory='$v' expected 32Mi"; exit 1; fi
