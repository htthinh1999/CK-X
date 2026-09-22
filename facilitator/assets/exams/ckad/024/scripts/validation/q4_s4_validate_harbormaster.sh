#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
rel=$(helm list -n berth -o json 2>/dev/null | jq -r '.[] | select(.name=="harbormaster") | "\(.status) \(.chart)"')
read -r status chart <<< "$rel"
[ "$status" = "deployed" ] || { echo "FAIL: release harbormaster not deployed in namespace berth (status='$status')"; exit 1; }
case "$chart" in dockyard-*) ;; *) echo "FAIL: harbormaster uses chart '$chart', expected dockyard"; exit 1 ;; esac

stype=$(helm get values harbormaster -n berth --all -o json 2>/dev/null | jq -r '.service.type // empty')
[ "$stype" = "NodePort" ] || { echo "FAIL: harbormaster value service.type='$stype' (expected NodePort)"; exit 1; }

live=$(kubectl -n berth get service -l app.kubernetes.io/instance=harbormaster -o jsonpath='{.items[*].spec.type}' 2>/dev/null)
if [ "$live" = "NodePort" ]; then
  echo "OK: harbormaster installed from dockyard with a NodePort Service"
  exit 0
fi
echo "FAIL: harbormaster Service type is '$live' (expected NodePort)"
exit 1
