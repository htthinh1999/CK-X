#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=sleepers; DEP=sleeper-berths

json=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
read -r gen obs spec total upd ready rev <<<"$(echo "$json" | jq -r '[.metadata.generation, (.status.observedGeneration // 0), (.spec.replicas // 0), (.status.replicas // 0), (.status.updatedReplicas // 0), (.status.readyReplicas // 0), (.metadata.annotations["deployment.kubernetes.io/revision"] // "")] | map(tostring) | join(" ")')"
[ "$spec" = "2" ] || { echo "ERR: $DEP has $spec replicas, expected 2"; exit 1; }
if [ "$obs" != "$gen" ] || [ "$total" != "2" ] || [ "$upd" != "2" ] || [ "$ready" != "2" ]; then
  echo "ERR: $DEP not fully rolled out and Ready (replicas=$total updated=$upd ready=$ready of 2)"
  exit 1
fi

hash=$(kubectl -n "$NS" get rs -l app=sleeper-berths -o json 2>/dev/null | jq -r --arg r "$rev" '[.items[] | select(.metadata.annotations["deployment.kubernetes.io/revision"] == $r)][0].metadata.labels["pod-template-hash"] // empty')
[ -n "$hash" ] || { echo "ERR: cannot find the current ReplicaSet of $DEP"; exit 1; }

pods=$(kubectl -n "$NS" get pods -l "app=sleeper-berths,pod-template-hash=$hash" -o json 2>/dev/null | jq -c '[.items[] | select(.metadata.deletionTimestamp == null)]')
n=$(echo "$pods" | jq 'length')
[ "$n" = "2" ] || { echo "ERR: expected 2 current Pods of $DEP, found $n"; exit 1; }
bad=$(echo "$pods" | jq -r '.[] | select(
    .status.phase != "Running"
    or ([.status.conditions[]? | select(.type=="Ready" and .status=="True")] | length) == 0
    or ((.status.containerStatuses // []) | length) != 2
    or ([.status.containerStatuses[]? | select(.restartCount != 0)] | length) > 0
  ) | "\(.metadata.name)(restarts=\([.status.containerStatuses[]?.restartCount] | add // 0))"')
[ -z "$bad" ] || { echo "ERR: current Pods not Ready or restarted: $bad"; exit 1; }

echo "OK: 2 current Pods of $DEP Ready with restartCount 0"
exit 0
