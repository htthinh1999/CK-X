#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
cnt=$(kubectl get pod logger-app -n stronghold -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | wc -w)
if [ "$cnt" -ge 2 ] 2>/dev/null; then echo "Success: pod has $cnt containers"; exit 0
else echo "Error: pod has fewer than 2 containers ($cnt)"; exit 1; fi
