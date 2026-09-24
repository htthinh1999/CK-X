#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
# pick a live (not terminating) pod of the new template whose log-tail container is ready
pod=$(kubectl -n winch get pods -l app=hoist-controller -o json 2>/dev/null | jq -r '
  [.items[]
   | select(.metadata.deletionTimestamp == null and .status.phase == "Running")
   | select(any(.spec.containers[]; .name == "log-tail"))
   | select(any(.status.containerStatuses[]?; .name == "log-tail" and .ready == true))
   | .metadata.name] | first // empty')
[ -n "$pod" ] || { echo "ERR: no running hoist-controller pod with a ready log-tail container"; exit 1; }
out=$(kubectl -n winch logs "$pod" -c log-tail --tail=50 2>/dev/null)
echo "$out" | grep -q "hoist cycle complete load=ok" && { echo "OK: kubectl logs -c log-tail shows the hoist log lines ($pod)"; exit 0; }
echo "ERR: log-tail output in $pod does not contain the hoist cycle lines"; exit 1
