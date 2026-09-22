#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
r=$(kubectl get deployment web-server -n citadel -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ -n "$r" ] && [ "$r" -ge 1 ] 2>/dev/null; then echo "Success: web-server has $r ready replicas"; exit 0
else echo "Error: web-server has no running pods"; exit 1; fi
