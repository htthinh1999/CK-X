#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deployment compute-app -n tower -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ -n "$r" ] && [ "$r" -ge 1 ] 2>/dev/null; then echo "Success: compute-app has $r ready replicas"; exit 0
else echo "Error: compute-app has no running pods"; exit 1; fi
