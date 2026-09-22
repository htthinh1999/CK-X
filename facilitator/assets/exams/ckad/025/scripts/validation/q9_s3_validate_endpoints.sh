#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=antenna; SVC=dish-receiver

ep=$(kubectl -n "$NS" get endpoints "$SVC" -o json 2>/dev/null) || { echo "FAIL: Endpoints $SVC not found in $NS"; exit 1; }

# Ready addresses in subsets that expose container port 80
n=$(echo "$ep" | jq '[.subsets[]? | select(any(.ports[]?; .port==80)) | .addresses[]?] | length')

if [ "$n" = "2" ]; then
  echo "PASS: Service $SVC has 2 ready endpoints on port 80"
  exit 0
fi
echo "FAIL: expected 2 ready endpoints on port 80, found ${n:-0}"
exit 1
