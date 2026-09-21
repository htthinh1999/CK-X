#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
vol=$(kubectl get pod thunder-logger -n thunder -o jsonpath='{.spec.volumes[0].emptyDir}' 2>/dev/null)
if [ -n "$vol" ]; then echo "Success: emptyDir volume configured"; exit 0; fi
echo "Error: emptyDir volume not configured"; exit 1
