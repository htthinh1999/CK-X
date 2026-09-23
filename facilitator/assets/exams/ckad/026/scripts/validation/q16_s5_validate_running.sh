#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=yardsafety; DEP=shunter

enf=$(kubectl get namespace "$NS" -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}' 2>/dev/null)
[ "$enf" = "restricted" ] || { echo "ERR: namespace $NS no longer enforces restricted"; exit 1; }

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
read -r gen obs spec total upd ready <<<"$(echo "$json" | jq -r '[.metadata.generation, (.status.observedGeneration // 0), (.spec.replicas // 0), (.status.replicas // 0), (.status.updatedReplicas // 0), (.status.readyReplicas // 0)] | map(tostring) | join(" ")')"
[ "$spec" = "2" ] || { echo "ERR: $DEP has $spec replicas, expected 2"; exit 1; }
if [ "$obs" != "$gen" ] || [ "$total" != "2" ] || [ "$upd" != "2" ] || [ "$ready" != "2" ]; then
  echo "ERR: $DEP is not fully rolled out and Ready (replicas=$total updated=$upd ready=$ready of 2)"
  exit 1
fi

pods=$(kubectl -n "$NS" get pods -l app=shunter -o json 2>/dev/null | jq -c '[.items[] | select(.metadata.deletionTimestamp == null)]')
bad=$(echo "$pods" | jq -r '.[] | select(.status.phase != "Running"
      or ([.status.conditions[]? | select(.type=="Ready" and .status=="True")] | length) == 0
      or ([.status.initContainerStatuses[]? | select(.name=="prep" and .state.terminated.exitCode == 0)] | length) != 1)
    | .metadata.name')
[ -z "$bad" ] || { echo "ERR: Pods not Running/Ready or init container prep not completed: $(echo $bad)"; exit 1; }

echo "OK: $DEP has 2/2 Ready Pods (prep completed) in a namespace that still enforces restricted"
exit 0
