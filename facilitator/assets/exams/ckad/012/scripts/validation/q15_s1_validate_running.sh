#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get deployment health-app -n tower >/dev/null 2>&1; then echo "Error: deployment health-app not found"; exit 1; fi
r=$(kubectl get deployment health-app -n tower -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ -n "$r" ] && [ "$r" -ge 1 ] 2>/dev/null; then echo "Success: health-app has $r ready replicas"; exit 0
else echo "Error: health-app has no running pods"; exit 1; fi
