#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
if ! kubectl get deployment legacy-app -n rampart >/dev/null 2>&1; then echo "Error: deployment legacy-app not found"; exit 1; fi
r=$(kubectl get deployment legacy-app -n rampart -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ -n "$r" ] && [ "$r" -ge 1 ] 2>/dev/null; then echo "Success: legacy-app has $r ready replicas"; exit 0
else echo "Error: legacy-app not running"; exit 1; fi
