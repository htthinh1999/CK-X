#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=antenna; SVC=dish-receiver

svc=$(kubectl -n "$NS" get service "$SVC" -o json 2>/dev/null) || { echo "FAIL: Service $SVC not found in $NS"; exit 1; }

type=$(echo "$svc" | jq -r '.spec.type')
np=$(echo "$svc" | jq -r '[.spec.ports[]? | select(.port==8080) | .nodePort][0] // empty | tostring')

if [ "$type" = "NodePort" ] && [ "$np" = "30725" ]; then
  echo "PASS: NodePort Service exposes port 8080 on nodePort 30725"
  exit 0
fi
echo "FAIL: expected type NodePort with port 8080 on nodePort 30725 (type=$type nodePort=$np)"
exit 1
