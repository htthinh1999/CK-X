#!/bin/bash
export KUBECONFIG=/home/candidate/.kube/kubeconfig
if ! kubectl get networkpolicy isolate-namespace -n nexus >/dev/null 2>&1; then
  echo "Error: networkpolicy isolate-namespace not found in nexus"
  exit 1
fi
psel=$(kubectl get networkpolicy isolate-namespace -n nexus -o jsonpath='{.spec.podSelector}' 2>/dev/null)
# An empty podSelector ({}) applies to all pods. kubectl may render it as {} or map[].
if [ "$psel" = "{}" ] || [ "$psel" = "map[]" ]; then
  echo "Success: podSelector is empty (applies to all pods)"
  exit 0
fi
echo "Error: podSelector is '$psel', expected empty {}"
exit 1
