#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=depot
DEP=wagon-sorter

NODE=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$NODE" ] || NODE=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
[ -n "$NODE" ] || { echo "ERR: cannot determine the depot node"; exit 1; }

# The depot node must still carry its taint and labels, and be the only depot node
nodes=$(kubectl get nodes -o json 2>/dev/null) || { echo "ERR: cannot list nodes"; exit 1; }
echo "$nodes" | jq -e --arg n "$NODE" '.items[] | select(.metadata.name==$n)
    | ([.spec.taints[]? | select(.key=="dedicated" and .value=="depot" and .effect=="NoSchedule")] | length) >= 1' >/dev/null 2>&1 \
  || { echo "ERR: taint dedicated=depot:NoSchedule was removed from $NODE"; exit 1; }
echo "$nodes" | jq -e --arg n "$NODE" '.items[] | select(.metadata.name==$n)
    | .metadata.labels["transit.io/pool"]=="depot" and .metadata.labels["transit.io/lane"]=="freight-b"' >/dev/null 2>&1 \
  || { echo "ERR: labels transit.io/pool=depot / transit.io/lane=freight-b on $NODE were changed"; exit 1; }
others=$(echo "$nodes" | jq -r --arg n "$NODE" '[.items[] | select(.metadata.name!=$n and .metadata.labels["transit.io/pool"]=="depot") | .metadata.name] | join(",")')
[ -z "$others" ] || { echo "ERR: other node(s) were labeled transit.io/pool=depot: $others"; exit 1; }

dep=$(kubectl -n "$NS" get deployment "$DEP" -o json 2>/dev/null) || { echo "ERR: Deployment $DEP not found"; exit 1; }
read -r spec ready updated avail < <(echo "$dep" | jq -r '"\(.spec.replicas) \(.status.readyReplicas // 0) \(.status.updatedReplicas // 0) \(.status.availableReplicas // 0)"')
[ "$spec" = "3" ] || { echo "ERR: $DEP has spec.replicas=$spec, expected 3"; exit 1; }
[ "$ready" = "3" ] && [ "$updated" = "3" ] && [ "$avail" = "3" ] \
  || { echo "ERR: $DEP ready=$ready updated=$updated available=$avail, expected 3/3/3"; exit 1; }

sel=$(echo "$dep" | jq -r '.spec.selector.matchLabels | to_entries | map("\(.key)=\(.value)") | join(",")')
pods=$(kubectl -n "$NS" get pods -l "$sel" -o json 2>/dev/null) || { echo "ERR: cannot list pods"; exit 1; }
live=$(echo "$pods" | jq -c '[.items[] | select(.metadata.deletionTimestamp == null)]')
total=$(echo "$live" | jq 'length')
good=$(echo "$live" | jq --arg n "$NODE" '[.[] | select(.spec.nodeName==$n and .status.phase=="Running")
          | select([.status.conditions[]? | select(.type=="Ready" and .status=="True")] | length > 0)] | length')
[ "$total" = "3" ] && [ "$good" = "3" ] || {
  echo "ERR: expected 3 Running+Ready $DEP pods, all on $NODE; found $good of $total"
  echo "$live" | jq -r '.[] | "  \(.metadata.name) node=\(.spec.nodeName // "-") phase=\(.status.phase)"'
  exit 1; }

echo "OK: 3/3 $DEP pods Running on tainted depot node $NODE"
exit 0
