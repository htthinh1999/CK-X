#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rel=$(helm list -n berth -o json 2>/dev/null | jq -r '.[] | select(.name=="tugboat") | "\(.status) \(.revision) \(.chart)"')
read -r status revision chart <<< "$rel"
[ "$status" = "deployed" ] || { echo "FAIL: release tugboat not deployed (status='$status')"; exit 1; }
[[ "$revision" =~ ^[0-9]+$ ]] && [ "$revision" -ge 2 ] || { echo "FAIL: release tugboat was not upgraded (revision='$revision')"; exit 1; }
case "$chart" in dockyard-*) ;; *) echo "FAIL: tugboat uses chart '$chart', expected dockyard"; exit 1 ;; esac

rc=$(helm get values tugboat -n berth --all -o json 2>/dev/null | jq -r '.replicaCount // empty')
[ "$rc" = "2" ] || { echo "FAIL: tugboat replicaCount='$rc' (expected 2)"; exit 1; }

ready=$(kubectl -n berth get deployment -l app.kubernetes.io/instance=tugboat -o jsonpath='{.items[0].status.readyReplicas}' 2>/dev/null)
if [ "${ready:-0}" = "2" ]; then
  echo "OK: tugboat upgraded (rev $revision) with replicaCount=2, 2 pods ready"
  exit 0
fi
echo "FAIL: tugboat deployment has '${ready:-0}' ready replicas (expected 2)"
exit 1
