#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
j=$(kubectl -n yard get horizontalpodautoscalers.v2.autoscaling forklift-hpa -o json 2>/dev/null) || { echo "ERR: hpa forklift-hpa not found in yard"; exit 1; }
r=$(echo "$j" | jq -r '"\(.spec.scaleTargetRef.kind)/\(.spec.scaleTargetRef.name)|\(.spec.minReplicas)|\(.spec.maxReplicas)|\([.spec.metrics[]? | select(.type == "Resource" and .resource.name == "cpu") | "\(.resource.target.type):\(.resource.target.averageUtilization)"] | join(","))"')
[ "$r" = "Deployment/forklift|2|5|Utilization:60" ] && { echo "OK: forklift-hpa targets forklift, min 2, max 5, cpu 60%"; exit 0; }
echo "ERR: live HPA target|min|max|cpu = '$r'"; exit 1
