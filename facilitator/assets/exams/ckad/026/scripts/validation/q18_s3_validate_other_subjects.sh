#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=freight
SAR=system:serviceaccount:freight:freight-reader
SAW=system:serviceaccount:freight:freight-writer

can() { kubectl auth can-i "$@" 2>/dev/null | head -1 | awk '{print $1}'; }

# the pre-existing edit grant must no longer reach freight-reader ...
for check in "delete pods" "create deployments.apps" "update services"; do
  [ "$(can $check -n "$NS" --as="$SAR")" = "no" ] || { echo "ERR: freight-reader still has '$check' in $NS (inherited from another binding)"; exit 1; }
done
# ... while user yardmaster keeps the edit access it had before
for check in "create configmaps" "get secrets/tariff-db" "delete deployments.apps"; do
  [ "$(can $check -n "$NS" --as=yardmaster)" = "yes" ] || { echo "ERR: user yardmaster lost permission '$check' in $NS"; exit 1; }
done
# ... and freight-writer keeps exactly its own Role
[ "$(can create configmaps -n "$NS" --as="$SAW")" = "yes" ] || { echo "ERR: freight-writer lost permission to create configmaps"; exit 1; }
[ "$(can get secrets/route-key -n "$NS" --as="$SAW")" = "no" ] || { echo "ERR: freight-writer gained access to secrets"; exit 1; }

echo "OK: extra grant removed from freight-reader; access of other subjects in $NS is unchanged"
exit 0
