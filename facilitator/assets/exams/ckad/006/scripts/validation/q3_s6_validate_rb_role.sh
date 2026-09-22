#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get rolebinding log-rb -n marsh -o jsonpath='{.roleRef.name}' 2>/dev/null)
if [ "$v" = "log-role" ]; then echo "Success: rolebinding references log-role"; exit 0; else echo "Error: roleRef is '$v', expected log-role"; exit 1; fi
