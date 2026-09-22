#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# Env var set in the spec, and the loop prints it (proves command + env work).
val=$(kubectl -n beacon get pod lamp-keeper -o jsonpath='{.spec.containers[0].env[?(@.name=="BEAM_COLOR")].value}' 2>/dev/null)
[ "$val" = "amber" ] || { echo "FAIL: env BEAM_COLOR='$val' (expected amber)"; exit 1; }
if kubectl -n beacon logs lamp-keeper --tail=50 2>/dev/null | grep -q 'beam=amber'; then
  echo "OK: BEAM_COLOR=amber and logs contain 'beam=amber'"
  exit 0
fi
echo "FAIL: logs of lamp-keeper do not contain 'beam=amber'"
exit 1
