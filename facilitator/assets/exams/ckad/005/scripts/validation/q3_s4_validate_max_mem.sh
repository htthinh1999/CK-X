#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get limitrange container-limits -n pounce -o jsonpath='{.spec.limits[?(@.type=="Container")].max.memory}' 2>/dev/null)
if [ "$v" = "512Mi" ]; then echo "Success: max memory 512Mi"; exit 0; else echo "Error: max memory='$v' expected 512Mi"; exit 1; fi
