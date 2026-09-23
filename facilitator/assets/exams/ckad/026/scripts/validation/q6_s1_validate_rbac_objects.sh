#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=freight
SA=freight-reader

kubectl -n "$NS" get serviceaccount "$SA" >/dev/null 2>&1 || { echo "ERR: ServiceAccount $SA not found in $NS"; exit 1; }
kubectl -n "$NS" get role freight-reader >/dev/null 2>&1 || { echo "ERR: Role freight-reader not found in $NS"; exit 1; }
rb=$(kubectl -n "$NS" get rolebinding freight-reader -o json 2>/dev/null) || { echo "ERR: RoleBinding freight-reader not found in $NS"; exit 1; }
echo "$rb" | jq -e '.roleRef.kind=="Role" and .roleRef.name=="freight-reader"' >/dev/null \
  || { echo "ERR: RoleBinding freight-reader does not reference Role freight-reader"; exit 1; }
echo "$rb" | jq -e --arg ns "$NS" --arg sa "$SA" 'any(.subjects[]?; .kind=="ServiceAccount" and .name==$sa and (.namespace // $ns)==$ns)' >/dev/null \
  || { echo "ERR: RoleBinding freight-reader has no subject ServiceAccount $NS/$SA"; exit 1; }

echo "OK: ServiceAccount, Role and RoleBinding freight-reader exist and are wired together"
exit 0
