#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q15/satpos-pdb.yaml

[ -f "$F" ] || { echo "FAIL: $F not found"; exit 1; }
grep -q 'policy/v1beta1' "$F" && { echo "FAIL: $F still references policy/v1beta1"; exit 1; }

# Client-side dry run only (nothing is created): the file must parse as a policy/v1 PDB
obj=$(kubectl create --dry-run=client -f "$F" -o json 2>/dev/null) || { echo "FAIL: $F cannot be processed by kubectl (unknown API version?)"; exit 1; }
ok=$(echo "$obj" | jq -r '.apiVersion=="policy/v1" and .kind=="PodDisruptionBudget" and .metadata.name=="satpos-pdb"' 2>/dev/null)
[ "$ok" = "true" ] || { echo "FAIL: $F must define PodDisruptionBudget satpos-pdb with apiVersion policy/v1"; exit 1; }

echo "PASS: $F uses policy/v1"
exit 0
