#!/bin/bash
export KUBECONFIG="${KUBECONFIG:-/home/candidate/.kube/kubeconfig}"
NS=wharf
json=$(kubectl -n "$NS" get pod forklift -o json 2>/dev/null) || { echo "FAIL: pod forklift not found in $NS"; exit 1; }

# The LimitRanger admission plugin records the defaults it injected, e.g.
# "LimitRanger plugin set: cpu, memory request for container forklift; cpu, memory limit for container forklift"
ann=$(echo "$json" | jq -r '.metadata.annotations["kubernetes.io/limit-ranger"] // empty')
[ -n "$ann" ] || { echo "FAIL: forklift was not defaulted by the LimitRange (resources were set in the Pod spec or the Pod was created before the LimitRange)"; exit 1; }

for word in request limit cpu memory; do
  echo "$ann" | grep -q "$word" || { echo "FAIL: LimitRange did not inject every default (annotation: $ann)"; exit 1; }
done

echo "OK: forklift received its requests and limits from the LimitRange"
exit 0
