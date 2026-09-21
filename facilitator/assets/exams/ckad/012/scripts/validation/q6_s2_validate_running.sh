#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
r=$(kubectl get deployment quota-app -n garrison -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
if [ -n "$r" ] && [ "$r" -ge 1 ] 2>/dev/null; then echo "Success: quota-app has $r ready replicas"; exit 0
else echo "Error: quota-app has no running pods"; exit 1; fi
