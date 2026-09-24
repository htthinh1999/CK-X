#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get pod log-collector -n marsh -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)
if [ "$v" = "log-sa" ]; then echo "Success: pod log-collector uses log-sa"; exit 0; else echo "Error: pod SA is '$v', expected log-sa"; exit 1; fi
