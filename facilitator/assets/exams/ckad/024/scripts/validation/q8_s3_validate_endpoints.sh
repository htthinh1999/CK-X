#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sel=$(kubectl -n tally get service weighbridge -o json 2>/dev/null | jq -c '.spec.selector // {}' 2>/dev/null)
[ "$sel" = '{"app":"weighbridge"}' ] || { echo "FAIL: service weighbridge missing or selector changed: '$sel'"; exit 1; }
names=$(kubectl -n tally get endpoints weighbridge -o jsonpath='{range .subsets[*].addresses[*]}{.targetRef.name}{"\n"}{end}' 2>/dev/null)
total=$(echo "$names" | grep -c '[^[:space:]]')
canary=$(echo "$names" | grep -c '^weighbridge-canary-')
if [ "$total" -eq 4 ] && [ "$canary" -eq 1 ]; then
  echo "OK: service weighbridge has 4 endpoints (1 canary)"
  exit 0
fi
echo "FAIL: service weighbridge has $total ready endpoints ($canary canary), expected 4 (1 canary)"
exit 1
