#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get configmap locked-config -n hunt -o jsonpath='{.immutable}' 2>/dev/null)
if [ "$v" = "true" ]; then echo "Success: configmap is immutable"; exit 0; else echo "Error: immutable='$v' expected true"; exit 1; fi
