#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
F=/home/candidate/exam/q9/forklift-hpa.yaml
[ -f "$F" ] || { echo "ERR: $F not found"; exit 1; }
# client-side parse only (nothing is created); fails if an apiVersion in the file is not served
j=$(kubectl create --dry-run=client --validate=false -f "$F" -o json 2>/dev/null) || { echo "ERR: $F does not parse against served APIs (still autoscaling/v2beta2?)"; exit 1; }
r=$(echo "$j" | jq -r '
  (if .kind == "List" then .items[] else . end) | select(.kind == "HorizontalPodAutoscaler")
  | "\(.apiVersion)|\(.metadata.name)|\(.spec.scaleTargetRef.kind)/\(.spec.scaleTargetRef.name)|\(.spec.minReplicas)|\(.spec.maxReplicas)|\([.spec.metrics[]? | select(.type == "Resource" and .resource.name == "cpu") | "\(.resource.target.type):\(.resource.target.averageUtilization)"] | join(","))"' | head -n1)
[ "$r" = "autoscaling/v2|forklift-hpa|Deployment/forklift|2|5|Utilization:60" ] && { echo "OK: file is autoscaling/v2 with the requested values"; exit 0; }
echo "ERR: file has apiVersion|name|target|min|max|cpu = '${r:-<no HPA found>}'"; exit 1
