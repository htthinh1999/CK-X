#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
json=$(kubectl -n tally get deployment weighbridge-canary -o json 2>/dev/null)
[ -z "$json" ] && { echo "FAIL: deployment weighbridge-canary not found in namespace tally"; exit 1; }
res=$(echo "$json" | jq -r '[
  (.spec.replicas // 0),
  .spec.template.spec.containers[0].image,
  (.spec.template.metadata.labels.app // "-"),
  (.spec.template.metadata.labels.track // "-"),
  (.status.readyReplicas // 0)
] | map(tostring) | join(" ")')
if [ "$res" = "1 nginx:1.26 weighbridge canary 1" ]; then
  echo "OK: weighbridge-canary has 1 ready nginx:1.26 replica labelled app=weighbridge,track=canary"
  exit 0
fi
echo "FAIL: replicas/image/app/track/ready = $res (expected 1 nginx:1.26 weighbridge canary 1)"
exit 1
