#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=tracker; HPA=satpos-hpa

json=$(kubectl -n "$NS" get horizontalpodautoscalers.v2.autoscaling "$HPA" -o json 2>/dev/null) || { echo "FAIL: HPA $HPA not found in $NS"; exit 1; }

ok=$(echo "$json" | jq -r '
  .spec.scaleTargetRef.kind=="Deployment" and
  .spec.scaleTargetRef.name=="satpos" and
  .spec.minReplicas==2 and
  .spec.maxReplicas==6 and
  ((.spec.metrics // []) | length)==1 and
  .spec.metrics[0].type=="Resource" and
  .spec.metrics[0].resource.name=="memory" and
  .spec.metrics[0].resource.target.type=="Utilization" and
  .spec.metrics[0].resource.target.averageUtilization==75
' 2>/dev/null)

if [ "$ok" = "true" ]; then
  echo "PASS: HPA $HPA targets Deployment satpos, 2-6 replicas, memory utilization 75%"
  exit 0
fi
echo "FAIL: HPA $HPA spec mismatch (got $(echo "$json" | jq -c '{scaleTargetRef:.spec.scaleTargetRef,min:.spec.minReplicas,max:.spec.maxReplicas,metrics:.spec.metrics}'))"
exit 1
