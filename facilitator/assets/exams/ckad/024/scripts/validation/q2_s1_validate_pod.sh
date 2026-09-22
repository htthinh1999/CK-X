#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
json=$(kubectl -n beacon get pod lamp-keeper -o json 2>/dev/null)
[ -z "$json" ] && { echo "FAIL: pod lamp-keeper not found in namespace beacon"; exit 1; }
img=$(echo "$json" | jq -r '.spec.containers[0].image')
lbl=$(echo "$json" | jq -r '.metadata.labels.tier // empty')
phase=$(echo "$json" | jq -r '.status.phase // empty')
if [ "$img" = "busybox:1.36" ] && [ "$lbl" = "signal" ] && [ "$phase" = "Running" ]; then
  echo "OK: lamp-keeper is Running (busybox:1.36, tier=signal)"
  exit 0
fi
echo "FAIL: image='$img' tier='$lbl' phase='$phase' (expected busybox:1.36 / signal / Running)"
exit 1
