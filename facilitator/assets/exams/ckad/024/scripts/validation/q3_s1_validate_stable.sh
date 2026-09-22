#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
json=$(kubectl -n tally get deployment weighbridge -o json 2>/dev/null)
[ -z "$json" ] && { echo "FAIL: deployment weighbridge not found in namespace tally"; exit 1; }
res=$(echo "$json" | jq -r '[(.spec.replicas // 0), .spec.template.spec.containers[0].image, (.status.readyReplicas // 0)] | map(tostring) | join(" ")')
if [ "$res" = "3 nginx:1.25 3" ]; then
  echo "OK: weighbridge has 3 ready replicas of nginx:1.25"
  exit 0
fi
echo "FAIL: replicas/image/ready = $res (expected 3 nginx:1.25 3)"
exit 1
