#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=junction; DEP=junction-green; WANT=4

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "FAIL: Deployment $DEP not found"; exit 1; }

spec=$(echo "$json" | jq -r '.spec.replicas')
[ "$spec" = "$WANT" ] || { echo "FAIL: $DEP must run $WANT replicas (the size of junction-blue), spec.replicas=$spec"; exit 1; }

img=$(echo "$json" | jq -r '[.spec.template.spec.containers[].image] | join(",")')
[ "$img" = "nginx:1.26" ] || { echo "FAIL: $DEP must keep image nginx:1.26 (got $img)"; exit 1; }

gen=$(echo "$json" | jq -r '.metadata.generation'); obs=$(echo "$json" | jq -r '.status.observedGeneration // 0')
upd=$(echo "$json" | jq -r '.status.updatedReplicas // 0')
rdy=$(echo "$json" | jq -r '.status.readyReplicas // 0')
tot=$(echo "$json" | jq -r '.status.replicas // 0')
if [ "$obs" -lt "$gen" ] || [ "$upd" != "$WANT" ] || [ "$rdy" != "$WANT" ] || [ "$tot" != "$WANT" ]; then
  echo "FAIL: $DEP is not fully rolled out and Ready (updated=$upd ready=$rdy total=$tot, want $WANT)"
  exit 1
fi
echo "PASS: $DEP runs $WANT Ready replicas of nginx:1.26"
exit 0
