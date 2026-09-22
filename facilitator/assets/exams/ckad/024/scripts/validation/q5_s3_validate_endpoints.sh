#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
ep=$(kubectl -n manifest get endpoints manifest-api -o json 2>/dev/null)
[ -z "$ep" ] && { echo "FAIL: endpoints manifest-api not found"; exit 1; }
names=$(echo "$ep" | jq -r '[.subsets[]? | .addresses[]? | .targetRef.name // ""] | .[]')
total=$(echo "$names" | grep -c '[^[:space:]]')
own=$(echo "$names" | grep -c '^manifest-api-')
ports=$(echo "$ep" | jq -r '[.subsets[]? | .ports[]? | .port] | unique | map(tostring) | join(",")')
if [ "$total" -eq 2 ] && [ "$own" -eq 2 ] && [ "$ports" = "80" ]; then
  echo "OK: service manifest-api has 2 ready endpoints on port 80"
  exit 0
fi
echo "FAIL: ready endpoints=$total (from manifest-api pods: $own), ports='$ports' (expected 2 endpoints on port 80)"
exit 1
