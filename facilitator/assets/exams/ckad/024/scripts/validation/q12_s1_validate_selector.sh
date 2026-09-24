#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
sel=$(kubectl -n manifest get service manifest-api -o json 2>/dev/null | jq -c '.spec.selector // {}' 2>/dev/null)
tpl=$(kubectl -n manifest get deployment manifest-api -o json 2>/dev/null | jq -c '.spec.template.metadata.labels // {}' 2>/dev/null)
[ -n "$sel" ] || { echo "FAIL: service manifest-api not found"; exit 1; }
[ -n "$tpl" ] || { echo "FAIL: deployment manifest-api not found"; exit 1; }

# The Deployment must be untouched (its pods keep app=manifest-api, tier=backend).
tapp=$(echo "$tpl" | jq -r '.app // empty')
ttier=$(echo "$tpl" | jq -r '.tier // empty')
[ "$tapp" = "manifest-api" ] && [ "$ttier" = "backend" ] || { echo "FAIL: Deployment pod labels were changed: $tpl"; exit 1; }

# Every selector key/value must be present on the Deployment's pod template.
ok=$(jq -n --argjson s "$sel" --argjson t "$tpl" '($s | length > 0) and ([$s | to_entries[] | $t[.key] == .value] | all)')
if [ "$ok" = "true" ]; then
  echo "OK: service selector $sel matches the manifest-api pods"
  exit 0
fi
echo "FAIL: service selector $sel does not match pod labels $tpl"
exit 1
