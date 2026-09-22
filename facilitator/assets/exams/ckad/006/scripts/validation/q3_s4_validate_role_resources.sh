#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get role log-role -n marsh -o jsonpath='{.rules[0].resources}' 2>/dev/null)
if [[ "$v" == *"pods"* ]]; then echo "Success: role targets pods"; exit 0; else echo "Error: role resources are '$v', expected pods"; exit 1; fi
