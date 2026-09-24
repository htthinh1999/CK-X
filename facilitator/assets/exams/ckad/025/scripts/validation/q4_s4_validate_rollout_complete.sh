#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=mirror
D=reflector

j=$(kubectl -n "$NS" get deployment "$D" -o json 2>/dev/null) || { echo "ERR: deployment $D not found"; exit 1; }
spec=$(echo "$j" | jq -r '.spec.replicas // 0')
gen=$(echo "$j" | jq -r '.metadata.generation // 0')
obs=$(echo "$j" | jq -r '.status.observedGeneration // 0')
total=$(echo "$j" | jq -r '.status.replicas // 0')
upd=$(echo "$j" | jq -r '.status.updatedReplicas // 0')
ready=$(echo "$j" | jq -r '.status.readyReplicas // 0')
avail=$(echo "$j" | jq -r '.status.availableReplicas // 0')

[ "$spec" -eq 3 ] || { echo "ERR: spec.replicas=$spec, expected 3"; exit 1; }
[ "$obs" -ge "$gen" ] || { echo "ERR: rollout not observed yet (generation $gen, observed $obs)"; exit 1; }
if [ "$total" -eq 3 ] && [ "$upd" -eq 3 ] && [ "$ready" -eq 3 ] && [ "$avail" -eq 3 ]; then
  # ignore old pods that are already terminating (they linger briefly after the rollout)
  imgs=$(kubectl -n "$NS" get pods -l app=reflector -o json 2>/dev/null \
    | jq -r '.items[] | select(.metadata.deletionTimestamp == null) | .spec.containers[].image' | sort -u | sed '/^$/d')
  [ "$imgs" = "nginx:1.26" ] || { echo "ERR: pods still running other images: $(echo $imgs)"; exit 1; }
  echo "OK: rollout complete (3/3 updated, ready, available)"
  exit 0
fi
echo "ERR: rollout incomplete: total=$total updated=$upd ready=$ready available=$avail"
exit 1
