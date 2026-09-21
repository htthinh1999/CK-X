#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
scopes=$(kubectl get resourcequota priority-quota -n eden -o jsonpath='{.spec.scopeSelector.matchExpressions[0].scopeName}' 2>/dev/null)
if [ "$scopes" = "PriorityClass" ]; then
  echo "Success: scopeSelector scopeName is PriorityClass"
  exit 0
fi
echo "Error: scopeSelector scopeName is '$scopes', expected PriorityClass"
exit 1
