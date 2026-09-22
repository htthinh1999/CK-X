#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
n=$(kubectl get deployment spread-pods -n tiger -o jsonpath='{.spec.template.spec.containers[0].name}' 2>/dev/null)
if [ "$n" = "web" ]; then echo "Success: container named web"; exit 0; else echo "Error: container='$n' expected web"; exit 1; fi
