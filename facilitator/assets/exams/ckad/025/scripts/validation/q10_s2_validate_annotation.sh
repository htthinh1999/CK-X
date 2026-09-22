#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=catalog; KEY=catalog.observatory.io/retention; VAL='hot=7d,cold=365d'

json=$(kubectl -n "$NS" get pods -o json 2>/dev/null) || { echo "FAIL: cannot list pods in $NS"; exit 1; }

ann() {
  echo "$json" | jq -r --arg p "$1" --arg k "$KEY" '[.items[] | select(.metadata.name==$p) | (.metadata.annotations[$k] // "<none>")][0] // "<missing pod>"'
}

for p in idx-bootes idx-draco idx-fornax; do
  got=$(ann "$p")
  [ "$got" = "$VAL" ] || { echo "FAIL: pod $p must have annotation $KEY=$VAL, got '$got'"; exit 1; }
done
for p in idx-andromeda idx-cygnus idx-eridanus; do
  got=$(ann "$p")
  [ "$got" = "<none>" ] || { echo "FAIL: pod $p (survey=deep) must not have annotation $KEY (got '$got')"; exit 1; }
done

echo "PASS: survey=wide pods carry $KEY=$VAL"
exit 0
