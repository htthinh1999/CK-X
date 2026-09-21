#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get deployment rolling-app -n parapet -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ -n "$r" ] && [ "$r" -ge 1 ] 2>/dev/null; then echo "Success: rolling-app has $r ready replicas"; exit 0
else echo "Error: rolling-app has no running pods"; exit 1; fi
