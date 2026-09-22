#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get service external-api -n fang -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
if [ -z "$v" ] || [ "$v" = "None" ]; then echo "Success: no ClusterIP"; exit 0; else echo "Error: clusterIP='$v' should be empty"; exit 1; fi
