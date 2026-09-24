#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=signal
json=$(kubectl -n "$NS" get service foghorn-svc -o json 2>/dev/null) || { echo "FAIL: service foghorn-svc not found in $NS"; exit 1; }

type=$(echo "$json" | jq -r '.spec.type // empty')
[ "$type" = "ClusterIP" ] || { echo "FAIL: service type is '$type' (expected ClusterIP)"; exit 1; }

sel=$(echo "$json" | jq -r '.spec.selector.app // empty')
[ "$sel" = "foghorn" ] || { echo "FAIL: service selector app='$sel' (expected foghorn)"; exit 1; }

if ! echo "$json" | jq -e '.spec.ports[]? | select(.port == 8080 and ((.targetPort | tostring) == "80"))' >/dev/null 2>&1; then
  echo "FAIL: service has no port 8080 with targetPort 80"; exit 1
fi

podip=$(kubectl -n "$NS" get pod foghorn -o jsonpath='{.status.podIP}' 2>/dev/null)
eps=$(kubectl -n "$NS" get endpoints foghorn-svc -o jsonpath='{.subsets[*].addresses[*].ip}' 2>/dev/null)
if [ -z "$podip" ] || ! echo " $eps " | grep -q " $podip "; then
  echo "FAIL: service endpoints '$eps' do not contain the foghorn pod IP '$podip'"; exit 1
fi

echo "OK: foghorn-svc is ClusterIP 8080->80 with the foghorn pod as endpoint"
exit 0
