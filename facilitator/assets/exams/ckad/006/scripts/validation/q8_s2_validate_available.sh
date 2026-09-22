#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
v=$(kubectl get deploy broken-app -n default -o jsonpath='{.status.availableReplicas}' 2>/dev/null)
if [ -n "$v" ] && [ "$v" -ge 1 ]; then echo "Success: broken-app has available replicas"; exit 0; else echo "Error: broken-app available replicas is '$v', expected >=1"; exit 1; fi
