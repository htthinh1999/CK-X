#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q1/revision.txt
[ -f "$F" ] || { echo "FAIL: $F not found"; exit 1; }
got=$(tr -d '[:space:]' < "$F")
rev=$(kubectl -n quayside get deployment crane -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}' 2>/dev/null)
# Setup created revisions 1-3; a rollback always creates a newer revision (>= 4).
if ! [[ "$rev" =~ ^[0-9]+$ ]] || [ "$rev" -lt 4 ]; then
  echo "FAIL: deployment revision is '$rev' - no rollback has happened yet"
  exit 1
fi
if [ "$got" = "$rev" ]; then
  echo "OK: revision.txt ($got) matches the active revision"
  exit 0
fi
echo "FAIL: revision.txt contains '$got' but the active revision is '$rev'"
exit 1
