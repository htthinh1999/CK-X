#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=tracker; PDB=satpos-pdb

json=$(kubectl -n "$NS" get poddisruptionbudgets.v1.policy "$PDB" -o json 2>/dev/null) || { echo "FAIL: PodDisruptionBudget $PDB not found in $NS"; exit 1; }

ok=$(echo "$json" | jq -r '(.spec.minAvailable|tostring)=="1" and .spec.selector.matchLabels.app=="satpos" and (.spec.maxUnavailable==null)')
if [ "$ok" = "true" ]; then
  echo "PASS: PDB $PDB (policy/v1) has minAvailable 1 and selects app=satpos"
  exit 0
fi
echo "FAIL: PDB $PDB must have minAvailable 1 and selector app=satpos (got $(echo "$json" | jq -c '.spec'))"
exit 1
