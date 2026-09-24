#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sel=$(kubectl get svc api-svc -n rampart -o jsonpath='{.spec.selector.app}' 2>/dev/null)
[ "$sel" = "api-server-green" ] && { echo "Success: api-svc selector app=api-server-green"; exit 0; }
echo "Error: api-svc selector.app is '$sel', expected api-server-green"; exit 1
