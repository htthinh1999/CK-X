#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
ns_sel=$(kubectl get networkpolicy strict-ingress -n charge -o jsonpath='{.spec.ingress[0].from[0].namespaceSelector.matchLabels.env}' 2>/dev/null)
p_sel=$(kubectl get networkpolicy strict-ingress -n charge -o jsonpath='{.spec.ingress[0].from[0].podSelector.matchLabels.role}' 2>/dev/null)
if [ "$ns_sel" = "prod" ] && [ "$p_sel" = "api" ]; then
  echo "Success: AND logic (namespaceSelector env=prod + podSelector role=api)"; exit 0
fi
echo "Error: AND logic missing (ns env='$ns_sel', pod role='$p_sel')"; exit 1
